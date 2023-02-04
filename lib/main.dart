import 'package:bws_agreement_creator/app_state.dart';
import 'package:bws_agreement_creator/main_scaffold.dart';
import 'package:bws_agreement_creator/utils/use_build_effect.dart';
import 'package:bws_agreement_creator/utils/user_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userData = await UserStorageHelper().getUserData();
  runApp(ProviderScope(
      child: MyApp(
    userData: userData,
  )));
}

class MyApp extends HookConsumerWidget {
  final StorageUserData? userData;
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
