import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
part 'form_controller.g.dart';

@CopyWith()
class FormState {
  final int? nettoValue;

  FormState({this.nettoValue});
}

class FormNotifier extends StateNotifier<FormState> {
  FormNotifier() : super(FormState(nettoValue: null));
  static final provider =
      StateNotifierProvider.autoDispose<FormNotifier, FormState>((ref) {
    return FormNotifier();
  });

  void setNettoValue(int? nettoValue) {
    state = state.copyWith(nettoValue: nettoValue);
  }
}
