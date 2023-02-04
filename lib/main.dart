import 'package:bws_agreement_creator/app_state.dart';
import 'package:bws_agreement_creator/main_scaffold.dart';
import 'package:bws_agreement_creator/utils/use_build_effect.dart';
import 'package:bws_agreement_creator/utils/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final isLoggedIn = await UserStorageHelper().isLoggedIn();
  runApp(ProviderScope(
      child: MyApp(
    isLoggedIn: isLoggedIn,
  )));
}

class MyApp extends HookConsumerWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context, ref) {
    useBuildEffect(() {
      ref.read(userAuthProvider.notifier).state = isLoggedIn;
      FlutterNativeSplash.remove();
    }, []);
    return MaterialApp(home: Scaffold(body: MainScaffold()));
  }
}
