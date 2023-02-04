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
import 'package:path/path.dart' as p;

class DriveData {
  static String configFileId = '1zU9kvQZ01Wtpvp_D8qDeeWjWVDkqxUga';
  static String folderId = '1dxNCpykaD0IeiY_OB2ePoAZjeBh5x-9r';
}

class GoogleDriveService {
  Future<void> getConfigFromDrive(WidgetRef ref) async {
    final authService = AuthService(ref: ref);
    final headers = await authService.getAccessToken();
    if (headers == null) {
      authService.signOut();
    }
    final authenticateClient = GoogleAuthClient(headers!);
    final driveApi = drive.DriveApi(authenticateClient);

    drive.FileList fileList = await driveApi.files.list(
        q: "name='default_config.json' and '${DriveData.folderId}' in parents");
    if (fileList.files?.isEmpty == true) {
      ref.read(errorProvider.notifier).state =
          "Nie znaleziono pliku konfiguracyjnego";
      AuthService(ref: ref).signOut();
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
        final content = String.fromCharCodes(dataStore);
        final decoded = Parser.parseItem(content, DefaultConfigData.fromJson);
        ref.read(userConfigProvider.notifier).state = decoded;
      } catch (error) {
        ref.read(errorProvider.notifier).state = error.toString();
        AuthService(ref: ref).signOut();
      }
    }, onError: (error) {
      ref.read(errorProvider.notifier).state = error.toString();
      AuthService(ref: ref).signOut();
    });
  }

  uploadFileToGoogleDrive(
      Map<String, String> headers, Uint8List data, String id) async {
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
        uploadMedia:
            drive.Media(Stream.fromIterable([data].toList()), data.length),
      );
      folderId = folderResponse.id;
    } else {
      folderId = result.files?.first.id ?? '';
    }

    fileToUpload.parents = [folderId];
    fileToUpload.name = "${DateTime.now().formattedDateWithDays}-$id.pdf";

    var response = await driveApi.files.create(
      fileToUpload,
      uploadMedia:
          drive.Media(Stream.fromIterable([data].toList()), data.length),
    );
    print(response);
  }
}
