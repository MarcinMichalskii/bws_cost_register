import 'package:bws_agreement_creator/app_state.dart';
import 'package:bws_agreement_creator/form_controller.dart';
import 'package:bws_agreement_creator/utils/auth_service.dart';
import 'package:bws_agreement_creator/utils/date_extensions.dart';
import 'package:bws_agreement_creator/utils/google_auth_client.dart';
import 'package:bws_agreement_creator/utils/google_drive_service.dart';
import 'package:bws_agreement_creator/utils/int_extension.dart';
import 'package:bws_agreement_creator/utils/pdf_helper.dart';
import 'package:collection/collection.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class GoogleData {
  static String spreadSheetId = '1IfHoFiqjsKY3E-iM4i63R_VPMUKz3h8hBJKNonP548E';
}

class GoogleSheetsService {
  Future<void> addNewEntry(CostFormState data, WidgetRef ref) async {
    final authService = AuthService(ref: ref);
    final headers = await authService.getAccessToken();

    final id = const Uuid().v4().toString();

    final pdfPhotos = await PdfHelper().generatePdfPage(data);
    final pdfDocument = data.pdfFile;

    await GoogleDriveService().uploadFileToGoogleDrive(
        headers,
        data.photos.isEmpty ? pdfDocument! : pdfPhotos,
        id,
        ref,
        data.nettoValue?.asPLN() ?? '',
        data.selectedDate);

    final sheetNames = await getSpreadSheetsNames(headers);
    if (!sheetNames.contains(data.selectedDate.formattedDate)) {
      await addNewSpreadSheet(headers, ref, data.selectedDate);
    }
    await addNewRow(headers, data, id, ref, data.selectedDate);
  }

  Future<void> addNewSpreadSheet(
      Map<String, String> headers, WidgetRef ref, DateTime date) async {
    try {
      final authenticateClient = GoogleAuthClient(headers);
      final newSheetTitle = date.formattedDate;
      sheets.SheetsApi sheetsApi = sheets.SheetsApi(authenticateClient);
      var sheetFile =
          await sheetsApi.spreadsheets.get(GoogleData.spreadSheetId);
      final templateSheetId = sheetFile.sheets
          ?.firstWhereOrNull(
              (element) => element.properties?.title == 'template')
          ?.properties
          ?.sheetId;

      await sheetsApi.spreadsheets.batchUpdate(
          sheets.BatchUpdateSpreadsheetRequest.fromJson({
            "requests": [
              {
                "duplicateSheet": {
                  "sourceSheetId": templateSheetId,
                  "insertSheetIndex": 0,
                  'newSheetName': newSheetTitle
                }
              }
            ]
          }),
          GoogleData.spreadSheetId);
    } catch (e) {
      ref.read(errorProvider.notifier).state = e.toString();
      AuthService(ref: ref).signOut();
    }
  }

  Future<List<String>> getSpreadSheetsNames(Map<String, String> headers) async {
    final authenticateClient = GoogleAuthClient(headers);
    sheets.SheetsApi sheetsApi = sheets.SheetsApi(authenticateClient);
    var sheetFile = await sheetsApi.spreadsheets.get(GoogleData.spreadSheetId);
    var ressheets = sheetFile.sheets;
    var sheetNames = ressheets
        ?.map((sheet) => sheet.properties?.title)
        .whereType<String>()
        .toList();
    return sheetNames ?? [];
  }

  Future<void> addNewRow(Map<String, String> headers, CostFormState data,
      String id, WidgetRef ref, DateTime date) async {
    final authenticateClient = GoogleAuthClient(headers);
    sheets.SheetsApi sheetsApi = sheets.SheetsApi(authenticateClient);
    final range =
        '${data.selectedDate.formattedDate}!A1:A'; // Change 'Sheet1' to your desired sheet name
    var response = await sheetsApi.spreadsheets.values
        .get(GoogleData.spreadSheetId, range);
    var values = response.values;
    var lastRow = (values?.length ?? 0) + 1;

    sheets.ValueRange vr = sheets.ValueRange.fromJson({
      "values": [
        [
          data.category,
          data.subcategory,
          (data.nettoValue?.asPLN() ?? ''),
          data.person,
          data.selectedDate.formattedDateWithDays,
          id
        ]
      ]
    });
    sheetsApi.spreadsheets.values
        .append(
            vr, GoogleData.spreadSheetId, '${date.formattedDate}!A${lastRow}',
            valueInputOption: 'USER_ENTERED')
        .then((sheets.AppendValuesResponse r) {})
        .onError((error, stackTrace) {
      ref.read(errorProvider.notifier).state = error.toString();
      AuthService(ref: ref).signOut();
    });
  }
}
