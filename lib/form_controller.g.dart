// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_controller.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FormStateCWProxy {
  FormState nettoValue(int? nettoValue);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FormState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FormState(...).copyWith(id: 12, name: "My name")
  /// ````
  FormState call({
    int? nettoValue,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFormState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFormState.copyWith.fieldName(...)`
class _$FormStateCWProxyImpl implements _$FormStateCWProxy {
  final FormState _value;

  const _$FormStateCWProxyImpl(this._value);

  @override
  FormState nettoValue(int? nettoValue) => this(nettoValue: nettoValue);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FormState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FormState(...).copyWith(id: 12, name: "My name")
  /// ````
  FormState call({
    Object? nettoValue = const $CopyWithPlaceholder(),
  }) {
    return FormState(
      nettoValue: nettoValue == const $CopyWithPlaceholder()
          ? _value.nettoValue
          // ignore: cast_nullable_to_non_nullable
          : nettoValue as int?,
    );
  }
}

extension $FormStateCopyWith on FormState {
  /// Returns a callable class that can be used as follows: `instanceOfFormState.copyWith(...)` or like so:`instanceOfFormState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FormStateCWProxy get copyWith => _$FormStateCWProxyImpl(this);
}
