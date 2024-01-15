import 'package:bws_agreement_creator/FormUI/login/form_screen.dart';
import 'package:bws_agreement_creator/FormUI/login/login_logic.dart';
import 'package:bws_agreement_creator/app_state.dart';
import 'package:bws_agreement_creator/utils/use_build_effect.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainScaffold extends HookConsumerWidget {
  final Map<String, String>? userData;
  const MainScaffold({super.key, this.userData});

  @override
  Widget build(BuildContext context, ref) {
    final error = ref.watch(errorProvider);
    useBuildEffect(() {
      if (error.isEmpty) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
      ));
      ref.read(errorProvider.notifier).state = '';
    }, [error]);

    final successMessage = ref.watch(successMessageProvider);
    useBuildEffect(() {
      if (successMessage.isEmpty) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(successMessage),
      ));
      ref.read(successMessageProvider.notifier).state = '';
    }, [successMessage]);
    final isLoggedIn = ref.watch(userAuthProvider);
    return isLoggedIn ? FormScreen() : LoginLogic();
  }
}
