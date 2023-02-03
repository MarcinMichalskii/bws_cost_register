// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_controller.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CostFormStateCWProxy {
  CostFormState category(String? category);

  CostFormState nettoValue(int? nettoValue);

  CostFormState pdfFile(Uint8List? pdfFile);

  CostFormState person(String? person);

  CostFormState photos(List<Uint8List> photos);

  CostFormState subcategory(String? subcategory);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CostFormState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CostFormState(...).copyWith(id: 12, name: "My name")
  /// ````
  CostFormState call({
    String? category,
    int? nettoValue,
    Uint8List? pdfFile,
    String? person,
    List<Uint8List>? photos,
    String? subcategory,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCostFormState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCostFormState.copyWith.fieldName(...)`
class _$CostFormStateCWProxyImpl implements _$CostFormStateCWProxy {
  final CostFormState _value;

  const _$CostFormStateCWProxyImpl(this._value);

  @override
  CostFormState category(String? category) => this(category: category);

  @override
  CostFormState nettoValue(int? nettoValue) => this(nettoValue: nettoValue);

  @override
  CostFormState pdfFile(Uint8List? pdfFile) => this(pdfFile: pdfFile);

  @override
  CostFormState person(String? person) => this(person: person);

  @override
  CostFormState photos(List<Uint8List> photos) => this(photos: photos);

  @override
  CostFormState subcategory(String? subcategory) =>
      this(subcategory: subcategory);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CostFormState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CostFormState(...).copyWith(id: 12, name: "My name")
  /// ````
  CostFormState call({
    Object? category = const $CopyWithPlaceholder(),
    Object? nettoValue = const $CopyWithPlaceholder(),
    Object? pdfFile = const $CopyWithPlaceholder(),
    Object? person = const $CopyWithPlaceholder(),
    Object? photos = const $CopyWithPlaceholder(),
    Object? subcategory = const $CopyWithPlaceholder(),
  }) {
    return CostFormState(
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as String?,
      nettoValue: nettoValue == const $CopyWithPlaceholder()
          ? _value.nettoValue
          // ignore: cast_nullable_to_non_nullable
          : nettoValue as int?,
      pdfFile: pdfFile == const $CopyWithPlaceholder()
          ? _value.pdfFile
          // ignore: cast_nullable_to_non_nullable
          : pdfFile as Uint8List?,
      person: person == const $CopyWithPlaceholder()
          ? _value.person
          // ignore: cast_nullable_to_non_nullable
          : person as String?,
      photos: photos == const $CopyWithPlaceholder() || photos == null
          ? _value.photos
          // ignore: cast_nullable_to_non_nullable
          : photos as List<Uint8List>,
      subcategory: subcategory == const $CopyWithPlaceholder()
          ? _value.subcategory
          // ignore: cast_nullable_to_non_nullable
          : subcategory as String?,
    );
  }
}

extension $CostFormStateCopyWith on CostFormState {
  /// Returns a callable class that can be used as follows: `instanceOfCostFormState.copyWith(...)` or like so:`instanceOfCostFormState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CostFormStateCWProxy get copyWith => _$CostFormStateCWProxyImpl(this);
}
