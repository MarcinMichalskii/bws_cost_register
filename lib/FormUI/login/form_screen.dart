import 'package:bws_agreement_creator/FormUI/login/form_logic.dart';
import 'package:bws_agreement_creator/utils/auth_service.dart';
import 'package:bws_agreement_creator/utils/colors.dart';
import 'package:bws_agreement_creator/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FormScreen extends HookConsumerWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, actions: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 8, 16, 8),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    CustomColors.applicationColorMain)),
            onPressed: () {
              AuthService(ref: ref).signOut();
            },
            child: Text('Wyloguj', style: TextStyle(color: Colors.black)),
          ),
        )
      ]),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              constraints:
                  const BoxConstraints(maxWidth: Consts.defaultMaxWidth),
              child: FormLogic()),
        ],
      ),
    );
  }
}
