import 'dart:convert';

import 'package:bws_agreement_creator/app_state.dart';
import 'package:bws_agreement_creator/utils/google_auth_client.dart';
import 'package:bws_agreement_creator/utils/user_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

// class TurboAuthService extends StateNotifier<String> {
//   final AutoDisposeStateNotifierProviderRef<dynamic, dynamic> ref;
//   TurboAuthService(this.ref) : super('');
//   static final provider =
//       StateNotifierProvider.autoDispose<TurboAuthService, void>((ref) {
//     return TurboAuthService(ref);
//   });
// }

final googleSignIn = GoogleSignIn.standard(
    scopes: [drive.DriveApi.driveScope, sheets.SheetsApi.spreadsheetsScope]);

class AuthService {
  AuthService({required this.ref});
  final WidgetRef ref;

  Future<Map<String, String>?> signOut() async {
    googleSignIn.signOut();
    ref.read(userAuthProvider.notifier).state = null;
    ref.read(userConfigProvider.notifier).state = null;
  }

  Future<void> signInWithGoogle() async {
    try {
      final account = await googleSignIn.signIn();

      final auth = await account?.authentication;
      print(auth?.accessToken);

      // if (auth?.idToken == null) {
      //   ref.read(errorProvider.notifier).state = 'Nie udało się zalogować';
      //   return;
      // }
      UserStorageHelper().storeUserData(StorageUserData('supertoken'));
      ref.read(userAuthProvider.notifier).state = StorageUserData('supertoken');
    } catch (e) {
      ref.read(errorProvider.notifier).state = e.toString();
    }
  }

  // Future<void> getRefreshToken(String idToken) async {
  //   const webKey =
  //       '837990215673-ltk4iuqngr70kkq3v6f8luk9tl4hd7fs.apps.googleusercontent.com';
  //   const androidKey = 'AIzaSyDPm9sWK0dVx1WsXgdKohKT_KvP8frOIbA';
  //   final key = kIsWeb ? webKey : androidKey;
  //   const provider = 'google.com';
  //   final url = Uri.parse(
  //       'https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=$key');

  //   print('tu jestem');
  //   final response = await http.post(url,
  //       headers: {'Content-type': 'application/json'},
  //       body: jsonEncode({
  //         'postBody': 'id_token=$idToken&providerId=$provider',
  //         'requestUri': 'http://localhost',
  //         'returnIdpCredential': true,
  //         'returnSecureToken': true
  //       }));
  //   if (response.statusCode != 200) {
  //     print('tu sie zjebalo');
  //     throw 'Refresh token request failed: ${response.statusCode}';
  //   }

  //   final data = Map<String, dynamic>.of(jsonDecode(response.body));
  //   if (data.containsKey('refreshToken')) {
  //     UserStorageHelper().storeUserData(StorageUserData(data['refreshToken']));
  //     print('to jednak wszystko git');
  //     ref.read(userAuthProvider.notifier).state =
  //         StorageUserData(data['refreshToken']);
  //   } else {
  //     print('albo tu');
  //     throw 'No refresh token in response';
  //   }
  // }

  Future<Map<String, String>> getAccessToken() async {
    // final googleSignIn = GoogleSignIn.standard(scopes: [
    //   drive.DriveApi.driveScope,
    //   sheets.SheetsApi.spreadsheetsScope
    // ]);
    // print('token1');
    // final token1 = await googleSignIn.currentUser?.authentication;
    // print(token1?.accessToken);
    final user = await googleSignIn.signInSilently();
    // user?.clearAuthCache();
    // final newUser = await googleSignIn.signInSilently();
    final auth = await user?.authentication;
    print(auth?.accessToken);
    ;
    final token = await googleSignIn.currentUser?.authentication;

    // print('token2');

    // return {'Authorization': 'Bearer ${token?.accessToken ?? ''}'};
    // const webKey =
    //     '837990215673-r9r67c3slqh2sa647dpdkhpbrt0ef7tt.apps.googleusercontent.com';
    // const androidKey = 'AIzaSyDPm9sWK0dVx1WsXgdKohKT_KvP8frOIbA';
    // final key = kIsWeb ? webKey : androidKey;
    // final webSecret = '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';
    // final url = Uri.parse('https://oauth2.googleapis.com/token');
    // final response = await http.post(
    //   url,
    //   headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    //   body: {
    //     'grant_type': 'refresh_token',
    //     'client_id':
    //         '837990215673-ltk4iuqngr70kkq3v6f8luk9tl4hd7fs.apps.googleusercontent.com',
    //     'client_secret': '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',
    //     'refresh_token': refreshToken,
    //   },
    // );

    // if (response.statusCode != 200) {
    //   print(response.body);
    //   throw 'Access token request failed: ${response.statusCode}';
    // }

    // final responseJson = json.decode(response.body);
    // final String token = responseJson['access_token'];
    return {'Authorization': 'Bearer ${token?.accessToken ?? ''}'};
  }

  // Future<Map<String, String>?> getAccessTokenUsingRefreshToken(
  //     String refreshToken) async {
  //   const webKey = 'AIzaSyAK1YNKY3uDWrLSlbPwwEtb4yVHq6bWDTU';
  //   const androidKey = 'AIzaSyDPm9sWK0dVx1WsXgdKohKT_KvP8frOIbA';
  //   final key = kIsWeb ? webKey : androidKey;
  //   final url = Uri.parse('https://oauth2.googleapis.com/token');

  //   final response = await http.post(url, headers: {
  //     'Content-type': 'application/x-www-form-urlencoded'
  //   }, body: {
  //     'grant_type': 'refresh_token',
  //     'refresh_token': refreshToken,
  //   });
  //   if (response.statusCode != 200) {
  //     throw 'Access token request failed: ${response.statusCode}';
  //   }

  //   final data = Map<String, dynamic>.of(jsonDecode(response.body));
  //   if (data.containsKey('access_token')) {
  //     final accessToken = data['access_token'] as String;
  //     print(data);
  //     return {'Authorization': 'Bearer $accessToken'};
  //   } else {
  //     throw 'No access token in response';
  //   }
  // }
}
