import 'package:bws_agreement_creator/FormUI/components/history_list.dart';
import 'package:bws_agreement_creator/FormUI/components/touchable_opacity.dart';
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
          TouchableOpacity(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return HistoryList(); // Replace with your custom view
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Icon(Icons.access_time,
                  color: CustomColors.applicationColorMain),
            ),
          ),
          Spacer(),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: Consts.defaultMaxWidth),
                    child: FormLogic()),
              ),
            ],
          ),
        ));
  }
}
