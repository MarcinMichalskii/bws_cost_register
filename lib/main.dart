import 'package:bws_agreement_creator/FormUI/login/form_logic.dart';
import 'package:bws_agreement_creator/FormUI/login/form_screen.dart';
import 'package:bws_agreement_creator/FormUI/login/login_logic.dart';
import 'package:bws_agreement_creator/app_state.dart';
import 'package:bws_agreement_creator/main_scaffold.dart';
import 'package:bws_agreement_creator/utils/auth_service.dart';
import 'package:bws_agreement_creator/utils/use_build_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userData = await AuthService().getGoogleAuthHeaders();
  runApp(ProviderScope(
      child: MyApp(
    userData: userData,
  )));
}

class MyApp extends HookConsumerWidget {
  final Map<String, String>? userData;
  const MyApp({super.key, this.userData});

  @override
  Widget build(BuildContext context, ref) {
    useBuildEffect(() {
      ref.read(userAuthProvider.notifier).state = userData;
    }, []);
    final userStoredData = ref.watch(userAuthProvider);
    return MaterialApp(home: Scaffold(body: MainScaffold()));
  }
}
