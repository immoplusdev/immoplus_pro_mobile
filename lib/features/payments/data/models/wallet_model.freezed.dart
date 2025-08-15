// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletModel _$WalletModelFromJson(Map<String, dynamic> json) {
  return _WalletModel.fromJson(json);
}

/// @nodoc
mixin _$WalletModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toInt, toJson: _fromInt)
  int get availableBalance => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _toInt, toJson: _fromInt)
  int get pendingBalance => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WalletModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletModelCopyWith<WalletModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletModelCopyWith<$Res> {
  factory $WalletModelCopyWith(
          WalletModel value, $Res Function(WalletModel) then) =
      _$WalletModelCopyWithImpl<$Res, WalletModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(fromJson: _toInt, toJson: _fromInt) int availableBalance,
      @JsonKey(fromJson: _toInt, toJson: _fromInt) int pendingBalance,
      String currency,
      @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
      DateTime? createdAt,
      @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
      DateTime? updatedAt});
}

/// @nodoc
class _$WalletModelCopyWithImpl<$Res, $Val extends WalletModel>
    implements $WalletModelCopyWith<$Res> {
  _$WalletModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? availableBalance = null,
    Object? pendingBalance = null,
    Object? currency = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      availableBalance: null == availableBalance
          ? _value.availableBalance
          : availableBalance // ignore: cast_nullable_to_non_nullable
              as int,
      pendingBalance: null == pendingBalance
          ? _value.pendingBalance
          : pendingBalance // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalletModelImplCopyWith<$Res>
    implements $WalletModelCopyWith<$Res> {
  factory _$$WalletModelImplCopyWith(
          _$WalletModelImpl value, $Res Function(_$WalletModelImpl) then) =
      __$$WalletModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(fromJson: _toInt, toJson: _fromInt) int availableBalance,
      @JsonKey(fromJson: _toInt, toJson: _fromInt) int pendingBalance,
      String currency,
      @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
      DateTime? createdAt,
      @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
      DateTime? updatedAt});
}

/// @nodoc
class __$$WalletModelImplCopyWithImpl<$Res>
    extends _$WalletModelCopyWithImpl<$Res, _$WalletModelImpl>
    implements _$$WalletModelImplCopyWith<$Res> {
  __$$WalletModelImplCopyWithImpl(
      _$WalletModelImpl _value, $Res Function(_$WalletModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? availableBalance = null,
    Object? pendingBalance = null,
    Object? currency = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WalletModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      availableBalance: null == availableBalance
          ? _value.availableBalance
          : availableBalance // ignore: cast_nullable_to_non_nullable
              as int,
      pendingBalance: null == pendingBalance
          ? _value.pendingBalance
          : pendingBalance // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletModelImpl implements _WalletModel {
  const _$WalletModelImpl(
      {this.id = '',
      @JsonKey(fromJson: _toInt, toJson: _fromInt) this.availableBalance = 0,
      @JsonKey(fromJson: _toInt, toJson: _fromInt) this.pendingBalance = 0,
      this.currency = 'XOF',
      @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) this.createdAt,
      @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) this.updatedAt});

  factory _$WalletModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey(fromJson: _toInt, toJson: _fromInt)
  final int availableBalance;
  @override
  @JsonKey(fromJson: _toInt, toJson: _fromInt)
  final int pendingBalance;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WalletModel(id: $id, availableBalance: $availableBalance, pendingBalance: $pendingBalance, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.availableBalance, availableBalance) ||
                other.availableBalance == availableBalance) &&
            (identical(other.pendingBalance, pendingBalance) ||
                other.pendingBalance == pendingBalance) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, availableBalance,
      pendingBalance, currency, createdAt, updatedAt);

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletModelImplCopyWith<_$WalletModelImpl> get copyWith =>
      __$$WalletModelImplCopyWithImpl<_$WalletModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletModelImplToJson(
      this,
    );
  }
}

abstract class _WalletModel implements WalletModel {
  const factory _WalletModel(
      {final String id,
      @JsonKey(fromJson: _toInt, toJson: _fromInt) final int availableBalance,
      @JsonKey(fromJson: _toInt, toJson: _fromInt) final int pendingBalance,
      final String currency,
      @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
      final DateTime? createdAt,
      @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
      final DateTime? updatedAt}) = _$WalletModelImpl;

  factory _WalletModel.fromJson(Map<String, dynamic> json) =
      _$WalletModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(fromJson: _toInt, toJson: _fromInt)
  int get availableBalance;
  @override
  @JsonKey(fromJson: _toInt, toJson: _fromInt)
  int get pendingBalance;
  @override
  String get currency;
  @override
  @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
  DateTime? get updatedAt;

  /// Create a copy of WalletModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletModelImplCopyWith<_$WalletModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
