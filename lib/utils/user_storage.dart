import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class StorageUserData {
//   final String refreshToken;
//   StorageUserData(this.refreshToken);
// }

class UserStorageHelper {
  final storage = const FlutterSecureStorage();

  Future<void> cleanupUserData() async {
    await storage.write(key: 'isLoggedIn', value: null);
  }

  Future<void> storeUserData(bool isLoggedIn) async {
    await storage.write(
        key: 'isLoggedIn', value: isLoggedIn ? 'true' : 'false');
  }

  Future<bool> isLoggedIn() async {
    final isLoggedInString = await storage.read(key: 'isLoggedIn');
    final bool isLoggedIn = isLoggedInString == 'true';
    return isLoggedIn;
  }
}
