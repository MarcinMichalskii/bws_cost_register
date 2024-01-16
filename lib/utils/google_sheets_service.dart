import 'package:bws_agreement_creator/app_state.dart';
import 'package:bws_agreement_creator/form_controller.dart';
import 'package:bws_agreement_creator/utils/auth_service.dart';
import 'package:bws_agreement_creator/utils/date_extensions.dart';
import 'package:bws_agreement_creator/utils/google_auth_client.dart';
import 'package:bws_agreement_creator/utils/google_drive_service.dart';
import 'package:bws_agreement_creator/utils/int_extension.dart';
import 'package:bws_agreement_creator/utils/pdf_helper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GoogleData {
  static String spreadSheetId = '14c7nDWmF1nF49do0BxtSybV7F2rXOhFL1G8TlWSta-w';
}

bool isDataSmallerThan10KB(Uint8List data) {
  final int dataSizeInBytes = data.lengthInBytes;
  final double dataSizeInKB = dataSizeInBytes / 1024.0;
  return dataSizeInKB < 5.0;
}

class GoogleSheetsService {
  Future<void> addNewEntry(CostFormState data, WidgetRef ref) async {
    final authService = AuthService(ref: ref);
    final headers = await authService.getAccessToken();

    final pdfPhotos = await PdfHelper().generatePdfPage(data);
    final pdfDocument = data.pdfFile;

    if (data.photos.isEmpty && isDataSmallerThan10KB(pdfDocument!)) {
      return Future.error(Error());
    }
    if (data.photos.isNotEmpty && isDataSmallerThan10KB(pdfPhotos)) {
      return Future.error(Error());
    }

    await GoogleDriveService().uploadFileToGoogleDrive(
        headers,
        data.photos.isEmpty ? pdfDocument! : pdfPhotos,
        data.id,
        ref,
        data.bruttoValue?.asPLN() ?? '',
        data.selectedDate);
    final sheetNames = await getSpreadSheetsNames(headers);
    if (!sheetNames.contains(data.selectedDate.formattedDate)) {
      await addNewSpreadSheet(headers, ref, data.selectedDate);
    }
    await addNewRow(headers, data, data.id, ref, data.selectedDate);
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
    final range = '${data.selectedDate.formattedDate}!A1:A';
    var response = await sheetsApi.spreadsheets.values
        .get(GoogleData.spreadSheetId, range);
    var values = response.values;
    var lastRow = (values?.length ?? 0) + 1;

    sheets.ValueRange vr = sheets.ValueRange.fromJson({
      "values": [
        [
          data.category,
          data.subcategory,
          (data.bruttoValue?.asPLN() ?? ''),
          data.person ?? '',
          data.selectedDate.formattedDateWithDays,
          data.orderNumber ?? '',
          data.description ?? '',
          id,
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
