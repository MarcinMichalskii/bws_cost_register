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
  static String spreadSheetId = '14c7nDWmF1nF49do0BxtSybV7F2rXOhFL1G8TlWSta-w';
}

class GoogleSheetsService {
  Future<void> addNewEntry(CostFormState data, WidgetRef ref) async {
    final authService = AuthService(ref: ref);
    final userData = ref.read(userAuthProvider);
    if (userData?.refreshToken == null) {
      authService.signOut();
      return;
    }
    final headers = await authService.getAccessToken();

    final id = const Uuid().v4().toString();
    if (headers == null) {
      AuthService(ref: ref).signOut();
      return;
    }
    final pdf = await PdfHelper().generatePdfPage(data);
    await GoogleDriveService().uploadFileToGoogleDrive(headers, pdf, id);
    final sheetNames = await getSpreadSheetsNames(headers);
    if (!sheetNames.contains(DateTime.now().formattedDate)) {
      await addNewSpreadSheet(headers);
    }
    await addNewRow(headers, data, id);
  }

  Future<void> addNewSpreadSheet(Map<String, String> headers) async {
    final authenticateClient = GoogleAuthClient(headers);
    final newSheetTitle = DateTime.now().formattedDate;
    sheets.SheetsApi sheetsApi = sheets.SheetsApi(authenticateClient);
    var sheetFile = await sheetsApi.spreadsheets.get(GoogleData.spreadSheetId);
    final templateSheetId = sheetFile.sheets
        ?.firstWhereOrNull((element) => element.properties?.title == 'template')
        ?.properties
        ?.sheetId;

    try {
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
      print(e);
    }
  }

  Future<void> updateCategories(Map<String, String> headers) async {
    final authenticateClient = GoogleAuthClient(headers);
    sheets.SheetsApi sheetsApi = sheets.SheetsApi(authenticateClient);
    var sheetFile = await sheetsApi.spreadsheets.get(GoogleData.spreadSheetId);
    final templateSheetId = sheetFile.sheets
        ?.firstWhereOrNull(
            (element) => element.properties?.title == 'Kategorie')
        ?.properties
        ?.sheetId;
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

  Future<void> addNewRow(
      Map<String, String> headers, CostFormState data, String id) async {
    final authenticateClient = GoogleAuthClient(headers);
    sheets.SheetsApi sheetsApi = sheets.SheetsApi(authenticateClient);
    final range =
        '${DateTime.now().formattedDate}!A1:A'; // Change 'Sheet1' to your desired sheet name
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
          DateTime.now().formattedDateWithDays,
          id
        ]
      ]
    });
    sheetsApi.spreadsheets.values
        .append(vr, GoogleData.spreadSheetId,
            '${DateTime.now().formattedDate}!A${lastRow}',
            valueInputOption: 'USER_ENTERED')
        .then((sheets.AppendValuesResponse r) {
      print('append completed.');
      // client.close();
    });
  }
}
