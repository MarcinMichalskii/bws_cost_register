import 'package:bws_agreement_creator/FormUI/login/form_logic.dart';
import 'package:bws_agreement_creator/FormUI/login/login_logic.dart';
import 'package:bws_agreement_creator/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    return MaterialApp(home: isLoggedIn ? FormLogic() : LoginLogic());
  }
}
