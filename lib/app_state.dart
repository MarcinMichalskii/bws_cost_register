import 'package:bws_agreement_creator/utils/default_config_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userAuthProvider = StateProvider<Map<String, String>?>((_) => null);
final userConfigProvider = StateProvider<DefaultConfigData?>((_) => null);
final errorProvider = StateProvider<String>((_) => '');
final isFormLoadingProvider = StateProvider<bool>((_) => false);
