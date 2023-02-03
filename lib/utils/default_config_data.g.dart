// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_config_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefaultConfigData _$DefaultConfigDataFromJson(Map<String, dynamic> json) =>
    DefaultConfigData(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
          .toList(),
      employees:
          (json['employees'] as List<dynamic>).map((e) => e as String).toList(),
    );
