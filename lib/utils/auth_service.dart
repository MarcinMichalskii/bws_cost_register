import 'package:bws_agreement_creator/app_state.dart';
import 'package:bws_agreement_creator/form_controller.dart';
import 'package:bws_agreement_creator/utils/user_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:hooks_riverpod/hooks_riverpod.dart';

final googleSignIn = GoogleSignIn.standard(
    scopes: [drive.DriveApi.driveScope, sheets.SheetsApi.spreadsheetsScope]);

class AuthService {
  AuthService({required this.ref});
  final WidgetRef ref;

  Future<Map<String, String>?> signOut() async {
    googleSignIn.disconnect();
    await googleSignIn.signOut();
    ref.read(userAuthProvider.notifier).state = false;
    ref.read(userConfigProvider.notifier).state = null;
    ref.read(FormNotifier.provider.notifier).clearForm();
  }

  Future<void> signInWithGoogle() async {
    try {
      final account = await googleSignIn.signIn();

      final auth = await account?.authentication;
      if (auth?.accessToken != null) {
        // UserStorageHelper().storeUserData(true);
        ref.read(tokenProvider.notifier).state = auth?.accessToken ?? '';
      } else {
        ref.read(errorProvider.notifier).state = 'Logowanie nie powiodło się';
        signOut();
      }
    } catch (e) {
      ref.read(errorProvider.notifier).state = e.toString();
      signOut();
    }
  }

  Future<Map<String, String>> getAccessToken() async {
    final token = ref.read(tokenProvider);
    return {'Authorization': 'Bearer $token'};
    // return kIsWeb ? getAccessTokenWeb() : getAccessTokenAndroid();
  }

  Future<Map<String, String>> getAccessTokenWeb() async {
    final user = await googleSignIn.signInSilently();
    final auth = await user?.authentication;
    if (auth?.accessToken == null) {
      ref.read(errorProvider.notifier).state = 'Błąd autoryzacji';
      signOut();
    }
    return {'Authorization': 'Bearer ${auth?.accessToken ?? ''}'};
  }

  Future<Map<String, String>> getAccessTokenAndroid() async {
    final oldUser = await googleSignIn.signInSilently();
    oldUser?.clearAuthCache();
    final newUser = await googleSignIn.signInSilently();
    final auth = await newUser?.authentication;
    if (auth?.accessToken == null) {
      ref.read(errorProvider.notifier).state = 'Błąd autoryzacji';
      signOut();
    }

    return {'Authorization': 'Bearer ${auth?.accessToken ?? ''}'};
  }
}
