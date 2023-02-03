import 'dart:core';
import 'package:bws_agreement_creator/utils/category_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'default_config_data.g.dart';

@JsonSerializable(createToJson: false)
class DefaultConfigData {
  DefaultConfigData({required this.categories, required this.employees});
  factory DefaultConfigData.fromJson(Map<String, dynamic> json) =>
      _$DefaultConfigDataFromJson(json);
  List<CategoryData> categories;
  List<String> employees;
}
