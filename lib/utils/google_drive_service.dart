import 'dart:convert';

import 'package:bws_agreement_creator/app_state.dart';
import 'package:bws_agreement_creator/utils/auth_service.dart';
import 'package:bws_agreement_creator/utils/date_extensions.dart';
import 'package:bws_agreement_creator/utils/default_config_data.dart';
import 'package:bws_agreement_creator/utils/google_auth_client.dart';
import 'package:bws_agreement_creator/utils/parser.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DriveData {
  static String folderId = '1tgxZkRK4HCBjlMFNUOrcgOtJkgBxjPj6';
}

class GoogleDriveService {
  Future<void> getConfigFromDrive(WidgetRef ref) async {
    final authService = AuthService(ref: ref);
    final headers = await authService.getAccessToken();
    try {
      final authenticateClient = GoogleAuthClient(headers);
      final driveApi = drive.DriveApi(authenticateClient);

      drive.FileList fileList = await driveApi.files.list(
        q: "name='default_config.json' and trashed = false and parents in '${DriveData.folderId}'",
        corpora: "drive",
        includeItemsFromAllDrives: true,
        driveId: "0AGznu2Ed0Pn5Uk9PVA",
        supportsAllDrives: true,
      );

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
          String jsonString = utf8.decode(dataStore);
          final decoded =
              Parser.parseItem(jsonString, DefaultConfigData.fromJson);
          ref.read(userConfigProvider.notifier).state = decoded;
        } catch (error) {
          ref.read(errorProvider.notifier).state = error.toString();
          AuthService(ref: ref).signOut();
        }
      }, onError: (error) {
        ref.read(errorProvider.notifier).state = error.toString();
        AuthService(ref: ref).signOut();
      });
    } catch (error) {
      ref.read(errorProvider.notifier).state = error.toString();
      AuthService(ref: ref).signOut();
    }
  }

  uploadFileToGoogleDrive(Map<String, String> headers, Uint8List data,
      String id, WidgetRef ref, String cost, DateTime date) async {
    try {
      final authenticateClient = GoogleAuthClient(headers);
      var driveApi = drive.DriveApi(authenticateClient);
      drive.File fileToUpload = drive.File();
      drive.File folderToUpload = drive.File();

      final folderName = date.formattedDate;
      final query =
          "mimeType='application/vnd.google-apps.folder' and name='$folderName' and parents in '${DriveData.folderId}'";
      final result = await driveApi.files.list(
        q: query,
        corpora: "drive",
        includeItemsFromAllDrives: true,
        driveId: "0AGznu2Ed0Pn5Uk9PVA",
        supportsAllDrives: true,
      );

      String folderId;
      if (result.files?.isEmpty == true) {
        folderToUpload.name = folderName;
        folderToUpload.mimeType = "application/vnd.google-apps.folder";
        folderToUpload.parents = [DriveData.folderId];

        var folderResponse = await driveApi.files.create(
          folderToUpload,
          uploadMedia: drive.Media(
            Stream.fromIterable([data].toList()),
            data.length,
          ),
          supportsAllDrives: true,
        );
        folderId = folderResponse.id ?? '';
      } else {
        folderId = result.files?.first.id ?? '';
      }

      fileToUpload.parents = [folderId];
      fileToUpload.name = "${date.formattedDateWithDays}-$cost-$id.pdf";

      await driveApi.files.create(
        fileToUpload,
        uploadMedia:
            drive.Media(Stream.fromIterable([data].toList()), data.length),
        supportsAllDrives: true,
      );
    } catch (error) {
      ref.read(errorProvider.notifier).state = error.toString();
      AuthService(ref: ref).signOut();
    }
  }
}
