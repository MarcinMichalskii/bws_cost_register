import 'package:bws_agreement_creator/FormUI/components/bws_logo.dart';
import 'package:bws_agreement_creator/utils/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginLogic extends HookConsumerWidget {
  const LoginLogic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 140),
                constraints: const BoxConstraints.expand(height: 140),
                child: BwsLogo()),
            Container(
              margin: const EdgeInsets.only(top: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignInButton(
                    Buttons.GoogleDark,
                    text: "    Zaloguj z Google",
                    onPressed: () async {
                      await AuthService(ref: ref).signInWithGoogle();
                    },
                  )
                ],
              ),
            )
          ],
        ));
  }
}
