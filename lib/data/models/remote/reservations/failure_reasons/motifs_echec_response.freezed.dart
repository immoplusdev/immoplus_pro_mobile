// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'motifs_echec_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MotifsEchecResponse _$MotifsEchecResponseFromJson(Map<String, dynamic> json) {
  return _MotifsEchecResponse.fromJson(json);
}

/// @nodoc
mixin _$MotifsEchecResponse {
  MotifsEchecData get data => throw _privateConstructorUsedError;

  /// Serializes this MotifsEchecResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MotifsEchecResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MotifsEchecResponseCopyWith<MotifsEchecResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MotifsEchecResponseCopyWith<$Res> {
  factory $MotifsEchecResponseCopyWith(
          MotifsEchecResponse value, $Res Function(MotifsEchecResponse) then) =
      _$MotifsEchecResponseCopyWithImpl<$Res, MotifsEchecResponse>;
  @useResult
  $Res call({MotifsEchecData data});

  $MotifsEchecDataCopyWith<$Res> get data;
}

/// @nodoc
class _$MotifsEchecResponseCopyWithImpl<$Res, $Val extends MotifsEchecResponse>
    implements $MotifsEchecResponseCopyWith<$Res> {
  _$MotifsEchecResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MotifsEchecResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as MotifsEchecData,
    ) as $Val);
  }

  /// Create a copy of MotifsEchecResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MotifsEchecDataCopyWith<$Res> get data {
    return $MotifsEchecDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MotifsEchecResponseImplCopyWith<$Res>
    implements $MotifsEchecResponseCopyWith<$Res> {
  factory _$$MotifsEchecResponseImplCopyWith(_$MotifsEchecResponseImpl value,
          $Res Function(_$MotifsEchecResponseImpl) then) =
      __$$MotifsEchecResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MotifsEchecData data});

  @override
  $MotifsEchecDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$MotifsEchecResponseImplCopyWithImpl<$Res>
    extends _$MotifsEchecResponseCopyWithImpl<$Res, _$MotifsEchecResponseImpl>
    implements _$$MotifsEchecResponseImplCopyWith<$Res> {
  __$$MotifsEchecResponseImplCopyWithImpl(_$MotifsEchecResponseImpl _value,
      $Res Function(_$MotifsEchecResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of MotifsEchecResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$MotifsEchecResponseImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as MotifsEchecData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MotifsEchecResponseImpl implements _MotifsEchecResponse {
  const _$MotifsEchecResponseImpl({required this.data});

  factory _$MotifsEchecResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MotifsEchecResponseImplFromJson(json);

  @override
  final MotifsEchecData data;

  @override
  String toString() {
    return 'MotifsEchecResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MotifsEchecResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of MotifsEchecResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MotifsEchecResponseImplCopyWith<_$MotifsEchecResponseImpl> get copyWith =>
      __$$MotifsEchecResponseImplCopyWithImpl<_$MotifsEchecResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MotifsEchecResponseImplToJson(
      this,
    );
  }
}

abstract class _MotifsEchecResponse implements MotifsEchecResponse {
  const factory _MotifsEchecResponse({required final MotifsEchecData data}) =
      _$MotifsEchecResponseImpl;

  factory _MotifsEchecResponse.fromJson(Map<String, dynamic> json) =
      _$MotifsEchecResponseImpl.fromJson;

  @override
  MotifsEchecData get data;

  /// Create a copy of MotifsEchecResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MotifsEchecResponseImplCopyWith<_$MotifsEchecResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MotifsEchecData _$MotifsEchecDataFromJson(Map<String, dynamic> json) {
  return _MotifsEchecData.fromJson(json);
}

/// @nodoc
mixin _$MotifsEchecData {
  String get reservationId => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get actorInterroge => throw _privateConstructorUsedError;
  bool get dejaRepondu => throw _privateConstructorUsedError;
  List<MotifItem> get motifs => throw _privateConstructorUsedError;

  /// Serializes this MotifsEchecData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MotifsEchecData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MotifsEchecDataCopyWith<MotifsEchecData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MotifsEchecDataCopyWith<$Res> {
  factory $MotifsEchecDataCopyWith(
          MotifsEchecData value, $Res Function(MotifsEchecData) then) =
      _$MotifsEchecDataCopyWithImpl<$Res, MotifsEchecData>;
  @useResult
  $Res call(
      {String reservationId,
      String? status,
      String? actorInterroge,
      bool dejaRepondu,
      List<MotifItem> motifs});
}

/// @nodoc
class _$MotifsEchecDataCopyWithImpl<$Res, $Val extends MotifsEchecData>
    implements $MotifsEchecDataCopyWith<$Res> {
  _$MotifsEchecDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MotifsEchecData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reservationId = null,
    Object? status = freezed,
    Object? actorInterroge = freezed,
    Object? dejaRepondu = null,
    Object? motifs = null,
  }) {
    return _then(_value.copyWith(
      reservationId: null == reservationId
          ? _value.reservationId
          : reservationId // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      actorInterroge: freezed == actorInterroge
          ? _value.actorInterroge
          : actorInterroge // ignore: cast_nullable_to_non_nullable
              as String?,
      dejaRepondu: null == dejaRepondu
          ? _value.dejaRepondu
          : dejaRepondu // ignore: cast_nullable_to_non_nullable
              as bool,
      motifs: null == motifs
          ? _value.motifs
          : motifs // ignore: cast_nullable_to_non_nullable
              as List<MotifItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MotifsEchecDataImplCopyWith<$Res>
    implements $MotifsEchecDataCopyWith<$Res> {
  factory _$$MotifsEchecDataImplCopyWith(_$MotifsEchecDataImpl value,
          $Res Function(_$MotifsEchecDataImpl) then) =
      __$$MotifsEchecDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String reservationId,
      String? status,
      String? actorInterroge,
      bool dejaRepondu,
      List<MotifItem> motifs});
}

/// @nodoc
class __$$MotifsEchecDataImplCopyWithImpl<$Res>
    extends _$MotifsEchecDataCopyWithImpl<$Res, _$MotifsEchecDataImpl>
    implements _$$MotifsEchecDataImplCopyWith<$Res> {
  __$$MotifsEchecDataImplCopyWithImpl(
      _$MotifsEchecDataImpl _value, $Res Function(_$MotifsEchecDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MotifsEchecData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reservationId = null,
    Object? status = freezed,
    Object? actorInterroge = freezed,
    Object? dejaRepondu = null,
    Object? motifs = null,
  }) {
    return _then(_$MotifsEchecDataImpl(
      reservationId: null == reservationId
          ? _value.reservationId
          : reservationId // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      actorInterroge: freezed == actorInterroge
          ? _value.actorInterroge
          : actorInterroge // ignore: cast_nullable_to_non_nullable
              as String?,
      dejaRepondu: null == dejaRepondu
          ? _value.dejaRepondu
          : dejaRepondu // ignore: cast_nullable_to_non_nullable
              as bool,
      motifs: null == motifs
          ? _value._motifs
          : motifs // ignore: cast_nullable_to_non_nullable
              as List<MotifItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MotifsEchecDataImpl implements _MotifsEchecData {
  const _$MotifsEchecDataImpl(
      {required this.reservationId,
      this.status,
      this.actorInterroge,
      this.dejaRepondu = false,
      final List<MotifItem> motifs = const []})
      : _motifs = motifs;

  factory _$MotifsEchecDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MotifsEchecDataImplFromJson(json);

  @override
  final String reservationId;
  @override
  final String? status;
  @override
  final String? actorInterroge;
  @override
  @JsonKey()
  final bool dejaRepondu;
  final List<MotifItem> _motifs;
  @override
  @JsonKey()
  List<MotifItem> get motifs {
    if (_motifs is EqualUnmodifiableListView) return _motifs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_motifs);
  }

  @override
  String toString() {
    return 'MotifsEchecData(reservationId: $reservationId, status: $status, actorInterroge: $actorInterroge, dejaRepondu: $dejaRepondu, motifs: $motifs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MotifsEchecDataImpl &&
            (identical(other.reservationId, reservationId) ||
                other.reservationId == reservationId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.actorInterroge, actorInterroge) ||
                other.actorInterroge == actorInterroge) &&
            (identical(other.dejaRepondu, dejaRepondu) ||
                other.dejaRepondu == dejaRepondu) &&
            const DeepCollectionEquality().equals(other._motifs, _motifs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      reservationId,
      status,
      actorInterroge,
      dejaRepondu,
      const DeepCollectionEquality().hash(_motifs));

  /// Create a copy of MotifsEchecData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MotifsEchecDataImplCopyWith<_$MotifsEchecDataImpl> get copyWith =>
      __$$MotifsEchecDataImplCopyWithImpl<_$MotifsEchecDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MotifsEchecDataImplToJson(
      this,
    );
  }
}

abstract class _MotifsEchecData implements MotifsEchecData {
  const factory _MotifsEchecData(
      {required final String reservationId,
      final String? status,
      final String? actorInterroge,
      final bool dejaRepondu,
      final List<MotifItem> motifs}) = _$MotifsEchecDataImpl;

  factory _MotifsEchecData.fromJson(Map<String, dynamic> json) =
      _$MotifsEchecDataImpl.fromJson;

  @override
  String get reservationId;
  @override
  String? get status;
  @override
  String? get actorInterroge;
  @override
  bool get dejaRepondu;
  @override
  List<MotifItem> get motifs;

  /// Create a copy of MotifsEchecData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MotifsEchecDataImplCopyWith<_$MotifsEchecDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
