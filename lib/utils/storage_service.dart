import 'dart:convert';

import 'package:bws_agreement_creator/form_controller.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String key = 'costFormStates';

  static Future<void> saveCostFormStates(List<CostFormState> states) async {
    final prefs = await SharedPreferences.getInstance();
    final dataList =
        states.map((state) => state.toSharedPreferences()).toList();
    await prefs.setString(key, jsonEncode(dataList));
  }

  static Future<List<CostFormState>> getCostFormStates() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      final List<dynamic> dataList = jsonDecode(jsonString);
      return dataList
          .map((data) => CostFormState.fromSharedPreferences(data))
          .toList();
    }
    return [];
  }

  static Future<void> appendCostFormState(CostFormState state) async {
    final list = await getCostFormStates();
    list.add(state);
    await saveCostFormStates(list);
  }

  static Future<void> clearCostFormStates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static markCostAsSent(String id) async {
    final list = await getCostFormStates();
    final element = list.firstWhereOrNull((element) => element.id == id);
    list.removeWhere((element) => element.id == id);
    if (element == null) {
      return;
    }
    final sent = element.copyWith(isSent: true);
    list.add(sent);
    saveCostFormStates(list);
  }
}
