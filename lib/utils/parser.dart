import 'dart:convert';

class Parser {
  static T parseItem<T>(
      String data, T Function(Map<String, dynamic> data) fromJson) {
    final items = json.decode(data) as Map<String, dynamic>;
    return fromJson(items);
  }
}
