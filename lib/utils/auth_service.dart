import 'package:bws_agreement_creator/app_state.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthService {
  Future<Map<String, String>?> signOut(WidgetRef ref) async {
    GoogleSignIn.standard().signOut();
    ref.read(userAuthProvider.notifier).state = null;
    ref.read(userConfigProvider.notifier).state = null;
  }

  Future<Map<String, String>?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.standard(scopes: [
      drive.DriveApi.driveScope,
      sheets.SheetsApi.spreadsheetsScope
    ]);
    final account = await googleSignIn.signIn();
    await googleSignIn.currentUser?.clearAuthCache();
    await googleSignIn.signInSilently();

    final authHeaders = account?.authHeaders;
    final jprdl = await googleSignIn.currentUser?.authentication;
    print(jprdl?.accessToken);
    print("DUPSKO");
    return authHeaders;
  }

  Future<Map<String, String>?> getGoogleAuthHeaders() async {
    final googleSignIn = GoogleSignIn.standard(scopes: [
      drive.DriveApi.driveScope,
      sheets.SheetsApi.spreadsheetsScope
    ]);

    await googleSignIn.signInSilently();
    await googleSignIn.currentUser?.clearAuthCache();
    final auth = await googleSignIn.currentUser?.authentication;
    await googleSignIn.signInSilently();
    return googleSignIn.currentUser?.authHeaders;
  }
}
