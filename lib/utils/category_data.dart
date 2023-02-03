import 'package:freezed_annotation/freezed_annotation.dart';
part 'category_data.g.dart';

@JsonSerializable(createToJson: false)
class CategoryData {
  CategoryData({required this.name, required this.subCategories});
  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);
  String name;
  List<String> subCategories;
}
