import 'package:bws_agreement_creator/FormUI/login/form_screen.dart';
import 'package:bws_agreement_creator/FormUI/login/login_logic.dart';
import 'package:bws_agreement_creator/app_state.dart';
import 'package:bws_agreement_creator/utils/auth_service.dart';
import 'package:bws_agreement_creator/utils/use_build_effect.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainScaffold extends HookConsumerWidget {
  final Map<String, String>? userData;
  const MainScaffold({super.key, this.userData});

  @override
  Widget build(BuildContext context, ref) {
    final error = ref.watch(errorProvider);
    useBuildEffect(() {
      googleSignIn.signInSilently();
      googleSignIn.onCurrentUserChanged.listen((event) async {
        final dupa = await event?.authentication;
        ref.read(tokenProvider.notifier).state = dupa?.accessToken ?? '';
        print(dupa);
        print("JAPIERDOLE");
      });
      if (error.isEmpty) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
      ));
      ref.read(errorProvider.notifier).state = '';
    }, [error]);
    final isLoggedIn = ref.watch(tokenProvider);
    return isLoggedIn.isNotEmpty ? FormScreen() : LoginLogic();
  }
}
