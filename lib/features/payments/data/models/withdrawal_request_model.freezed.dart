// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'withdrawal_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WithdrawalRequestModel _$WithdrawalRequestModelFromJson(
    Map<String, dynamic> json) {
  return _WithdrawalRequestModel.fromJson(json);
}

/// @nodoc
mixin _$WithdrawalRequestModel {
  String? get id => throw _privateConstructorUsedError;
  String? get owner => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseDouble)
  double? get amount => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  String? get operator => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this WithdrawalRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WithdrawalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WithdrawalRequestModelCopyWith<WithdrawalRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WithdrawalRequestModelCopyWith<$Res> {
  factory $WithdrawalRequestModelCopyWith(WithdrawalRequestModel value,
          $Res Function(WithdrawalRequestModel) then) =
      _$WithdrawalRequestModelCopyWithImpl<$Res, WithdrawalRequestModel>;
  @useResult
  $Res call(
      {String? id,
      String? owner,
      @JsonKey(fromJson: parseDouble) double? amount,
      String? currency,
      String? operator,
      String? phoneNumber,
      String? status,
      String? note,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? updatedAt,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? deletedAt});
}

/// @nodoc
class _$WithdrawalRequestModelCopyWithImpl<$Res,
        $Val extends WithdrawalRequestModel>
    implements $WithdrawalRequestModelCopyWith<$Res> {
  _$WithdrawalRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WithdrawalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? owner = freezed,
    Object? amount = freezed,
    Object? currency = freezed,
    Object? operator = freezed,
    Object? phoneNumber = freezed,
    Object? status = freezed,
    Object? note = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      owner: freezed == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      operator: freezed == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WithdrawalRequestModelImplCopyWith<$Res>
    implements $WithdrawalRequestModelCopyWith<$Res> {
  factory _$$WithdrawalRequestModelImplCopyWith(
          _$WithdrawalRequestModelImpl value,
          $Res Function(_$WithdrawalRequestModelImpl) then) =
      __$$WithdrawalRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? owner,
      @JsonKey(fromJson: parseDouble) double? amount,
      String? currency,
      String? operator,
      String? phoneNumber,
      String? status,
      String? note,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? createdAt,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? updatedAt,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      DateTime? deletedAt});
}

/// @nodoc
class __$$WithdrawalRequestModelImplCopyWithImpl<$Res>
    extends _$WithdrawalRequestModelCopyWithImpl<$Res,
        _$WithdrawalRequestModelImpl>
    implements _$$WithdrawalRequestModelImplCopyWith<$Res> {
  __$$WithdrawalRequestModelImplCopyWithImpl(
      _$WithdrawalRequestModelImpl _value,
      $Res Function(_$WithdrawalRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WithdrawalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? owner = freezed,
    Object? amount = freezed,
    Object? currency = freezed,
    Object? operator = freezed,
    Object? phoneNumber = freezed,
    Object? status = freezed,
    Object? note = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_$WithdrawalRequestModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      owner: freezed == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      operator: freezed == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WithdrawalRequestModelImpl implements _WithdrawalRequestModel {
  _$WithdrawalRequestModelImpl(
      {this.id = '',
      this.owner = '',
      @JsonKey(fromJson: parseDouble) this.amount = 0.0,
      this.currency = '',
      this.operator = '',
      this.phoneNumber = '',
      this.status,
      this.note = '',
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      this.createdAt,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      this.updatedAt,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      this.deletedAt});

  factory _$WithdrawalRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WithdrawalRequestModelImplFromJson(json);

  @override
  @JsonKey()
  final String? id;
  @override
  @JsonKey()
  final String? owner;
  @override
  @JsonKey(fromJson: parseDouble)
  final double? amount;
  @override
  @JsonKey()
  final String? currency;
  @override
  @JsonKey()
  final String? operator;
  @override
  @JsonKey()
  final String? phoneNumber;
  @override
  final String? status;
  @override
  @JsonKey()
  final String? note;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? updatedAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'WithdrawalRequestModel(id: $id, owner: $owner, amount: $amount, currency: $currency, operator: $operator, phoneNumber: $phoneNumber, status: $status, note: $note, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WithdrawalRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, owner, amount, currency,
      operator, phoneNumber, status, note, createdAt, updatedAt, deletedAt);

  /// Create a copy of WithdrawalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WithdrawalRequestModelImplCopyWith<_$WithdrawalRequestModelImpl>
      get copyWith => __$$WithdrawalRequestModelImplCopyWithImpl<
          _$WithdrawalRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WithdrawalRequestModelImplToJson(
      this,
    );
  }
}

abstract class _WithdrawalRequestModel implements WithdrawalRequestModel {
  factory _WithdrawalRequestModel(
      {final String? id,
      final String? owner,
      @JsonKey(fromJson: parseDouble) final double? amount,
      final String? currency,
      final String? operator,
      final String? phoneNumber,
      final String? status,
      final String? note,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      final DateTime? createdAt,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      final DateTime? updatedAt,
      @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
      final DateTime? deletedAt}) = _$WithdrawalRequestModelImpl;

  factory _WithdrawalRequestModel.fromJson(Map<String, dynamic> json) =
      _$WithdrawalRequestModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get owner;
  @override
  @JsonKey(fromJson: parseDouble)
  double? get amount;
  @override
  String? get currency;
  @override
  String? get operator;
  @override
  String? get phoneNumber;
  @override
  String? get status;
  @override
  String? get note;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get updatedAt;
  @override
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? get deletedAt;

  /// Create a copy of WithdrawalRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WithdrawalRequestModelImplCopyWith<_$WithdrawalRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
