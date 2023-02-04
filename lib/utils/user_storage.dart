import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageUserData {
  final String refreshToken;
  StorageUserData(this.refreshToken);
}

class UserStorageHelper {
  final storage = const FlutterSecureStorage();

  Future<void> cleanupUserData() async {
    await storage.write(key: 'refreshToken', value: null);
  }

  Future<void> storeUserData(StorageUserData data) async {
    await storage.write(key: 'refreshToken', value: data.refreshToken);
  }

  Future<StorageUserData?> getUserData() async {
    final token = await storage.read(key: 'refreshToken');
    if (token == null) {
      return null;
    }
    return StorageUserData(token);
  }
}
