import 'dart:io';

import 'package:bws_agreement_creator/app_state.dart';
import 'package:bws_agreement_creator/utils/auth_service.dart';
import 'package:bws_agreement_creator/utils/date_extensions.dart';
import 'package:bws_agreement_creator/utils/default_config_data.dart';
import 'package:bws_agreement_creator/utils/google_auth_client.dart';
import 'package:bws_agreement_creator/utils/parser.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class DriveData {
  static String configFileId = '1zU9kvQZ01Wtpvp_D8qDeeWjWVDkqxUga';
  static String folderId = '1dxNCpykaD0IeiY_OB2ePoAZjeBh5x-9r';
}

class GoogleDriveService {
  Future<void> getConfigFromDrive(
      Map<String, String> headers, WidgetRef ref) async {
    final authenticateClient = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(authenticateClient);

    print(headers);
    drive.FileList fileList = await driveApi.files.list(
        q: "name='default_config.json' and '${DriveData.folderId}' in parents");
    if (fileList.files?.isEmpty == true) {
      ref.read(errorProvider.notifier).state =
          "Nie znaleziono pliku konfiguracyjnego";
      AuthService().signOut(ref);
      return;
    }
    drive.File file = fileList.files!.first;
    drive.Media response = await driveApi.files.get(
      file.id ?? '',
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    List<int> dataStore = [];

    response.stream.listen((data) {
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      try {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File file = File('$tempPath/tempFile');
        await file.writeAsBytes(dataStore);
        final content = file.readAsStringSync();
        final decoded = Parser.parseItem(content, DefaultConfigData.fromJson);
        ref.read(userConfigProvider.notifier).state = decoded;
      } catch (error) {
        ref.read(errorProvider.notifier).state = error.toString();
        AuthService().signOut(ref);
      }
    }, onError: (error) {
      ref.read(errorProvider.notifier).state = error.toString();
      AuthService().signOut(ref);
    });
  }

  // uploadFileToGoogleDrive(
  //     Map<String, String> headers, Uint8List data, String id) async {
  //   Directory tempDir = await getTemporaryDirectory();
  //   String tempPath = tempDir.path;
  //   File file = File('$tempPath/tempFile');
  //   await file.writeAsBytes(data);
  //   final authenticateClient = GoogleAuthClient(headers);
  //   var driveApi = drive.DriveApi(authenticateClient);
  //   drive.File fileToUpload = drive.File();

  //   final list = await driveApi.files.list();
  //   print(list.files?.map((e) => e.name));

  //   fileToUpload.parents = ["1dxNCpykaD0IeiY_OB2ePoAZjeBh5x-9r"];
  //   fileToUpload.name = "${DateTime.now().formattedDateWithDays}-$id.pdf";

  //   var response = await driveApi.files.create(
  //     fileToUpload,
  //     uploadMedia: drive.Media(file.openRead(), data.length),
  //   );
  //   print(response);
  // }

  uploadFileToGoogleDrive(
      Map<String, String> headers, Uint8List data, String id) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath/tempFile');
    await file.writeAsBytes(data);
    final authenticateClient = GoogleAuthClient(headers);
    var driveApi = drive.DriveApi(authenticateClient);
    drive.File fileToUpload = drive.File();
    drive.File folderToUpload = drive.File();

    final folderName = "${DateTime.now().formattedDate}";
    final parentFolderId = "1dxNCpykaD0IeiY_OB2ePoAZjeBh5x-9r";
    final query =
        "mimeType='application/vnd.google-apps.folder' and name='$folderName' and parents in '$parentFolderId'";
    final result = await driveApi.files.list(q: query);

    var folderId;
    if (result.files?.isEmpty == true) {
      folderToUpload.name = folderName;
      folderToUpload.mimeType = "application/vnd.google-apps.folder";
      folderToUpload.parents = [parentFolderId];

      var folderResponse = await driveApi.files.create(
        folderToUpload,
        uploadMedia: drive.Media(file.openRead(), data.length),
      );
      folderId = folderResponse.id;
    } else {
      folderId = result.files?.first.id ?? '';
    }

    fileToUpload.parents = [folderId];
    fileToUpload.name = "${DateTime.now().formattedDateWithDays}-$id.pdf";

    var response = await driveApi.files.create(
      fileToUpload,
      uploadMedia: drive.Media(file.openRead(), data.length),
    );
    print(response);
  }

  // Future<void> uploadPdfToDrive(
  //   Uint8List pdf,
  //   Map<String, String> headers,
  // ) async {
  //   final authenticateClient = GoogleAuthClient(headers);
  //   final driveAPI = drive.DriveApi(authenticateClient);
  //   drive.
  //   final file = drive.MultipartFile.fromBytes('application/pdf', pdf,
  //       filename: 'koszt.pdf');

  //   final fileMetadata = drive.File();
  //   fileMetadata.name = 'koszt.pdf';
  //   fileMetadata.parents = [folderId];

  //   final media = drive.Media(file, 'application/pdf');

  //   final response = await driveAPI.files.create(fileMetadata, media: media);

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to upload file');
  //   }
  // }

  // Future<String?> _getFolderId(drive.DriveApi driveApi) async {
  //   final mimeType = "application/vnd.google-apps.folder";
  //   String folderName = "personalDiaryBackup";

  //   try {
  //     final found = await driveApi.files.list(
  //       q: "mimeType = '$mimeType' and name = '$folderName'",
  //       $fields: "files(id, name)",
  //     );
  //     final files = found.files;
  //     if (files == null) {
  //       print("Sign-in first Error");
  //       return null;
  //     }

  //     // The folder already exists
  //     if (files.isNotEmpty) {
  //       return files.first.id;
  //     }

  //     // Create a folder
  //     drive.File folder = drive.File();
  //     folder.name = folderName;
  //     folder.mimeType = mimeType;
  //     final folderCreation = await driveApi.files.create(folder);
  //     print("Folder ID: ${folderCreation.id}");

  //     return folderCreation.id;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  // uploadFileToGoogleDrive(File file, Map<String, String> headers) async {
  //   final authenticateClient = GoogleAuthClient(headers);
  //   final driveAPI = drive.DriveApi(authenticateClient);
  //   String? folderId = await _getFolderId(driveAPI);
  //   if (folderId == null) {
  //     print("Sign-in first Error");
  //   } else {
  //     drive.File fileToUpload = drive.File();
  //     fileToUpload.parents = [folderId];
  //     fileToUpload.name = p.basename(file.absolute.path);
  //     var response = await drive.files.create(
  //       fileToUpload,
  //       uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
  //     );
  //     print(response);
  //   }
  // }

// Replace
}
