import 'package:bws_agreement_creator/FormUI/components/bws_logo.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FormLogic extends HookConsumerWidget {
  const FormLogic({Key? key}) : super(key: key);

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
                  Text(
                    'zalogowano',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
