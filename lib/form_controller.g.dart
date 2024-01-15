// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_controller.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CostFormStateCWProxy {
  CostFormState bruttoValue(int? bruttoValue);

  CostFormState category(String? category);

  CostFormState id(String id);

  CostFormState isSent(bool isSent);

  CostFormState orderNumber(String? orderNumber);

  CostFormState pdfFile(Uint8List? pdfFile);

  CostFormState person(String? person);

  CostFormState photos(List<Uint8List> photos);

  CostFormState selectedDate(DateTime selectedDate);

  CostFormState subcategory(String? subcategory);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CostFormState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CostFormState(...).copyWith(id: 12, name: "My name")
  /// ````
  CostFormState call({
    int? bruttoValue,
    String? category,
    String? id,
    bool? isSent,
    String? orderNumber,
    Uint8List? pdfFile,
    String? person,
    List<Uint8List>? photos,
    DateTime? selectedDate,
    String? subcategory,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCostFormState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCostFormState.copyWith.fieldName(...)`
class _$CostFormStateCWProxyImpl implements _$CostFormStateCWProxy {
  final CostFormState _value;

  const _$CostFormStateCWProxyImpl(this._value);

  @override
  CostFormState bruttoValue(int? bruttoValue) => this(bruttoValue: bruttoValue);

  @override
  CostFormState category(String? category) => this(category: category);

  @override
  CostFormState id(String id) => this(id: id);

  @override
  CostFormState isSent(bool isSent) => this(isSent: isSent);

  @override
  CostFormState orderNumber(String? orderNumber) =>
      this(orderNumber: orderNumber);

  @override
  CostFormState pdfFile(Uint8List? pdfFile) => this(pdfFile: pdfFile);

  @override
  CostFormState person(String? person) => this(person: person);

  @override
  CostFormState photos(List<Uint8List> photos) => this(photos: photos);

  @override
  CostFormState selectedDate(DateTime selectedDate) =>
      this(selectedDate: selectedDate);

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
    Object? bruttoValue = const $CopyWithPlaceholder(),
    Object? category = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? isSent = const $CopyWithPlaceholder(),
    Object? orderNumber = const $CopyWithPlaceholder(),
    Object? pdfFile = const $CopyWithPlaceholder(),
    Object? person = const $CopyWithPlaceholder(),
    Object? photos = const $CopyWithPlaceholder(),
    Object? selectedDate = const $CopyWithPlaceholder(),
    Object? subcategory = const $CopyWithPlaceholder(),
  }) {
    return CostFormState(
      bruttoValue: bruttoValue == const $CopyWithPlaceholder()
          ? _value.bruttoValue
          // ignore: cast_nullable_to_non_nullable
          : bruttoValue as int?,
      category: category == const $CopyWithPlaceholder()
          ? _value.category
          // ignore: cast_nullable_to_non_nullable
          : category as String?,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      isSent: isSent == const $CopyWithPlaceholder() || isSent == null
          ? _value.isSent
          // ignore: cast_nullable_to_non_nullable
          : isSent as bool,
      orderNumber: orderNumber == const $CopyWithPlaceholder()
          ? _value.orderNumber
          // ignore: cast_nullable_to_non_nullable
          : orderNumber as String?,
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
      selectedDate:
          selectedDate == const $CopyWithPlaceholder() || selectedDate == null
              ? _value.selectedDate
              // ignore: cast_nullable_to_non_nullable
              : selectedDate as DateTime,
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
