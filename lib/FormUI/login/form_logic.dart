import 'package:bws_agreement_creator/FormUI/components/bordered_input.dart';
import 'package:bws_agreement_creator/FormUI/components/bws_logo.dart';
import 'package:bws_agreement_creator/app_state.dart';
import 'package:bws_agreement_creator/form_controller.dart';
import 'package:bws_agreement_creator/utils/colors.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FormLogic extends HookConsumerWidget {
  const FormLogic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wageFormatter =
        CurrencyTextInputFormatter(symbol: 'zł', locale: 'pl_pl');
    final setWage = useCallback((String? formattedValue) {
      final wageInCents = wageFormatter.getUnformattedValue() * 100;
      if (formattedValue?.isEmpty == true) {
        ref.read(FormNotifier.provider.notifier).setNettoValue(null);
      } else {
        ref
            .read(FormNotifier.provider.notifier)
            .setNettoValue(wageInCents.toInt());
      }
    }, [wageFormatter]);

    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 48, right: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            CustomColors.applicationColorMain)),
                    onPressed: () {
                      ref.read(isLoggedInProvider.notifier).state = false;
                    },
                    child:
                        Text('Wyloguj', style: TextStyle(color: Colors.black)),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: BorderedInput(
                inputType: TextInputType.number,
                onChanged: setWage,
                placeholder: 'Kwota netto',
                inputFormatters: [wageFormatter],
              ),
            )
          ],
        ));
  }
}
