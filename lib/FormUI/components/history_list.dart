import 'package:bws_agreement_creator/form_controller.dart';
import 'package:bws_agreement_creator/utils/int_extension.dart';
import 'package:bws_agreement_creator/utils/storage_service.dart';
import 'package:bws_agreement_creator/utils/use_build_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class HistoryList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final transactions = useState<List<CostFormState>>([]);

    Future<void> loadData() async {
      final values = await StorageService.getCostFormStates();
      // Sort transactions based on the display date
      values.sort((a, b) => a.selectedDate.compareTo(b.selectedDate));
      transactions.value = values;
    }

    useBuildEffect(() {
      loadData();
    }, []);

    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 0; i < transactions.value.length; i++)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Text(
                              transactions.value[i].person ?? '',
                              style: TextStyle(
                                color: transactions.value[i].isSent
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Text(
                                ' ${formatDate(transactions.value[i].selectedDate)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(transactions.value[i].category ?? ''),
                          const Text(' '),
                          Text(
                            transactions.value[i].subcategory ?? '',
                          ),
                          const Text(' '),
                          Text(
                            '${transactions.value[i].bruttoValue?.asPLN()} zł',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (i <
                    transactions.value.length - 1) // Add divider between rows
                  Divider(),
              ],
            ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}
