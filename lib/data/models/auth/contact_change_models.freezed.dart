// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_change_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestContactChangeBody _$RequestContactChangeBodyFromJson(
    Map<String, dynamic> json) {
  return _RequestContactChangeBody.fromJson(json);
}

/// @nodoc
mixin _$RequestContactChangeBody {
  @JsonKey(name: 'type')
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'phoneNumber')
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String? get email => throw _privateConstructorUsedError;

  /// Serializes this RequestContactChangeBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestContactChangeBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestContactChangeBodyCopyWith<RequestContactChangeBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestContactChangeBodyCopyWith<$Res> {
  factory $RequestContactChangeBodyCopyWith(RequestContactChangeBody value,
          $Res Function(RequestContactChangeBody) then) =
      _$RequestContactChangeBodyCopyWithImpl<$Res, RequestContactChangeBody>;
  @useResult
  $Res call(
      {@JsonKey(name: 'type') String type,
      @JsonKey(name: 'phoneNumber') String? phoneNumber,
      @JsonKey(name: 'email') String? email});
}

/// @nodoc
class _$RequestContactChangeBodyCopyWithImpl<$Res,
        $Val extends RequestContactChangeBody>
    implements $RequestContactChangeBodyCopyWith<$Res> {
  _$RequestContactChangeBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestContactChangeBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? phoneNumber = freezed,
    Object? email = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestContactChangeBodyImplCopyWith<$Res>
    implements $RequestContactChangeBodyCopyWith<$Res> {
  factory _$$RequestContactChangeBodyImplCopyWith(
          _$RequestContactChangeBodyImpl value,
          $Res Function(_$RequestContactChangeBodyImpl) then) =
      __$$RequestContactChangeBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'type') String type,
      @JsonKey(name: 'phoneNumber') String? phoneNumber,
      @JsonKey(name: 'email') String? email});
}

/// @nodoc
class __$$RequestContactChangeBodyImplCopyWithImpl<$Res>
    extends _$RequestContactChangeBodyCopyWithImpl<$Res,
        _$RequestContactChangeBodyImpl>
    implements _$$RequestContactChangeBodyImplCopyWith<$Res> {
  __$$RequestContactChangeBodyImplCopyWithImpl(
      _$RequestContactChangeBodyImpl _value,
      $Res Function(_$RequestContactChangeBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestContactChangeBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? phoneNumber = freezed,
    Object? email = freezed,
  }) {
    return _then(_$RequestContactChangeBodyImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestContactChangeBodyImpl implements _RequestContactChangeBody {
  const _$RequestContactChangeBodyImpl(
      {@JsonKey(name: 'type') required this.type,
      @JsonKey(name: 'phoneNumber') this.phoneNumber,
      @JsonKey(name: 'email') this.email});

  factory _$RequestContactChangeBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestContactChangeBodyImplFromJson(json);

  @override
  @JsonKey(name: 'type')
  final String type;
  @override
  @JsonKey(name: 'phoneNumber')
  final String? phoneNumber;
  @override
  @JsonKey(name: 'email')
  final String? email;

  @override
  String toString() {
    return 'RequestContactChangeBody(type: $type, phoneNumber: $phoneNumber, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestContactChangeBodyImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, phoneNumber, email);

  /// Create a copy of RequestContactChangeBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestContactChangeBodyImplCopyWith<_$RequestContactChangeBodyImpl>
      get copyWith => __$$RequestContactChangeBodyImplCopyWithImpl<
          _$RequestContactChangeBodyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestContactChangeBodyImplToJson(
      this,
    );
  }
}

abstract class _RequestContactChangeBody implements RequestContactChangeBody {
  const factory _RequestContactChangeBody(
          {@JsonKey(name: 'type') required final String type,
          @JsonKey(name: 'phoneNumber') final String? phoneNumber,
          @JsonKey(name: 'email') final String? email}) =
      _$RequestContactChangeBodyImpl;

  factory _RequestContactChangeBody.fromJson(Map<String, dynamic> json) =
      _$RequestContactChangeBodyImpl.fromJson;

  @override
  @JsonKey(name: 'type')
  String get type;
  @override
  @JsonKey(name: 'phoneNumber')
  String? get phoneNumber;
  @override
  @JsonKey(name: 'email')
  String? get email;

  /// Create a copy of RequestContactChangeBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestContactChangeBodyImplCopyWith<_$RequestContactChangeBodyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ConfirmContactChangeBody _$ConfirmContactChangeBodyFromJson(
    Map<String, dynamic> json) {
  return _ConfirmContactChangeBody.fromJson(json);
}

/// @nodoc
mixin _$ConfirmContactChangeBody {
  @JsonKey(name: 'type')
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'otp')
  String get otp => throw _privateConstructorUsedError;

  /// Serializes this ConfirmContactChangeBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConfirmContactChangeBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfirmContactChangeBodyCopyWith<ConfirmContactChangeBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfirmContactChangeBodyCopyWith<$Res> {
  factory $ConfirmContactChangeBodyCopyWith(ConfirmContactChangeBody value,
          $Res Function(ConfirmContactChangeBody) then) =
      _$ConfirmContactChangeBodyCopyWithImpl<$Res, ConfirmContactChangeBody>;
  @useResult
  $Res call(
      {@JsonKey(name: 'type') String type, @JsonKey(name: 'otp') String otp});
}

/// @nodoc
class _$ConfirmContactChangeBodyCopyWithImpl<$Res,
        $Val extends ConfirmContactChangeBody>
    implements $ConfirmContactChangeBodyCopyWith<$Res> {
  _$ConfirmContactChangeBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConfirmContactChangeBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? otp = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConfirmContactChangeBodyImplCopyWith<$Res>
    implements $ConfirmContactChangeBodyCopyWith<$Res> {
  factory _$$ConfirmContactChangeBodyImplCopyWith(
          _$ConfirmContactChangeBodyImpl value,
          $Res Function(_$ConfirmContactChangeBodyImpl) then) =
      __$$ConfirmContactChangeBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'type') String type, @JsonKey(name: 'otp') String otp});
}

/// @nodoc
class __$$ConfirmContactChangeBodyImplCopyWithImpl<$Res>
    extends _$ConfirmContactChangeBodyCopyWithImpl<$Res,
        _$ConfirmContactChangeBodyImpl>
    implements _$$ConfirmContactChangeBodyImplCopyWith<$Res> {
  __$$ConfirmContactChangeBodyImplCopyWithImpl(
      _$ConfirmContactChangeBodyImpl _value,
      $Res Function(_$ConfirmContactChangeBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConfirmContactChangeBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? otp = null,
  }) {
    return _then(_$ConfirmContactChangeBodyImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfirmContactChangeBodyImpl implements _ConfirmContactChangeBody {
  const _$ConfirmContactChangeBodyImpl(
      {@JsonKey(name: 'type') required this.type,
      @JsonKey(name: 'otp') required this.otp});

  factory _$ConfirmContactChangeBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfirmContactChangeBodyImplFromJson(json);

  @override
  @JsonKey(name: 'type')
  final String type;
  @override
  @JsonKey(name: 'otp')
  final String otp;

  @override
  String toString() {
    return 'ConfirmContactChangeBody(type: $type, otp: $otp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfirmContactChangeBodyImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.otp, otp) || other.otp == otp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, otp);

  /// Create a copy of ConfirmContactChangeBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfirmContactChangeBodyImplCopyWith<_$ConfirmContactChangeBodyImpl>
      get copyWith => __$$ConfirmContactChangeBodyImplCopyWithImpl<
          _$ConfirmContactChangeBodyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfirmContactChangeBodyImplToJson(
      this,
    );
  }
}

abstract class _ConfirmContactChangeBody implements ConfirmContactChangeBody {
  const factory _ConfirmContactChangeBody(
          {@JsonKey(name: 'type') required final String type,
          @JsonKey(name: 'otp') required final String otp}) =
      _$ConfirmContactChangeBodyImpl;

  factory _ConfirmContactChangeBody.fromJson(Map<String, dynamic> json) =
      _$ConfirmContactChangeBodyImpl.fromJson;

  @override
  @JsonKey(name: 'type')
  String get type;
  @override
  @JsonKey(name: 'otp')
  String get otp;

  /// Create a copy of ConfirmContactChangeBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfirmContactChangeBodyImplCopyWith<_$ConfirmContactChangeBodyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ContactChangeResponse _$ContactChangeResponseFromJson(
    Map<String, dynamic> json) {
  return _ContactChangeResponse.fromJson(json);
}

/// @nodoc
mixin _$ContactChangeResponse {
  @JsonKey(name: 'data')
  ContactChangeResponseData get data => throw _privateConstructorUsedError;

  /// Serializes this ContactChangeResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactChangeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactChangeResponseCopyWith<ContactChangeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactChangeResponseCopyWith<$Res> {
  factory $ContactChangeResponseCopyWith(ContactChangeResponse value,
          $Res Function(ContactChangeResponse) then) =
      _$ContactChangeResponseCopyWithImpl<$Res, ContactChangeResponse>;
  @useResult
  $Res call({@JsonKey(name: 'data') ContactChangeResponseData data});

  $ContactChangeResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class _$ContactChangeResponseCopyWithImpl<$Res,
        $Val extends ContactChangeResponse>
    implements $ContactChangeResponseCopyWith<$Res> {
  _$ContactChangeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactChangeResponse
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
              as ContactChangeResponseData,
    ) as $Val);
  }

  /// Create a copy of ContactChangeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContactChangeResponseDataCopyWith<$Res> get data {
    return $ContactChangeResponseDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ContactChangeResponseImplCopyWith<$Res>
    implements $ContactChangeResponseCopyWith<$Res> {
  factory _$$ContactChangeResponseImplCopyWith(
          _$ContactChangeResponseImpl value,
          $Res Function(_$ContactChangeResponseImpl) then) =
      __$$ContactChangeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'data') ContactChangeResponseData data});

  @override
  $ContactChangeResponseDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$ContactChangeResponseImplCopyWithImpl<$Res>
    extends _$ContactChangeResponseCopyWithImpl<$Res,
        _$ContactChangeResponseImpl>
    implements _$$ContactChangeResponseImplCopyWith<$Res> {
  __$$ContactChangeResponseImplCopyWithImpl(_$ContactChangeResponseImpl _value,
      $Res Function(_$ContactChangeResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactChangeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$ContactChangeResponseImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ContactChangeResponseData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactChangeResponseImpl implements _ContactChangeResponse {
  const _$ContactChangeResponseImpl(
      {@JsonKey(name: 'data') required this.data});

  factory _$ContactChangeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactChangeResponseImplFromJson(json);

  @override
  @JsonKey(name: 'data')
  final ContactChangeResponseData data;

  @override
  String toString() {
    return 'ContactChangeResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactChangeResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of ContactChangeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactChangeResponseImplCopyWith<_$ContactChangeResponseImpl>
      get copyWith => __$$ContactChangeResponseImplCopyWithImpl<
          _$ContactChangeResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactChangeResponseImplToJson(
      this,
    );
  }
}

abstract class _ContactChangeResponse implements ContactChangeResponse {
  const factory _ContactChangeResponse(
          {@JsonKey(name: 'data')
          required final ContactChangeResponseData data}) =
      _$ContactChangeResponseImpl;

  factory _ContactChangeResponse.fromJson(Map<String, dynamic> json) =
      _$ContactChangeResponseImpl.fromJson;

  @override
  @JsonKey(name: 'data')
  ContactChangeResponseData get data;

  /// Create a copy of ContactChangeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactChangeResponseImplCopyWith<_$ContactChangeResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ContactChangeResponseData _$ContactChangeResponseDataFromJson(
    Map<String, dynamic> json) {
  return _ContactChangeResponseData.fromJson(json);
}

/// @nodoc
mixin _$ContactChangeResponseData {
  @JsonKey(name: 'message')
  String get message => throw _privateConstructorUsedError;

  /// Serializes this ContactChangeResponseData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContactChangeResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContactChangeResponseDataCopyWith<ContactChangeResponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactChangeResponseDataCopyWith<$Res> {
  factory $ContactChangeResponseDataCopyWith(ContactChangeResponseData value,
          $Res Function(ContactChangeResponseData) then) =
      _$ContactChangeResponseDataCopyWithImpl<$Res, ContactChangeResponseData>;
  @useResult
  $Res call({@JsonKey(name: 'message') String message});
}

/// @nodoc
class _$ContactChangeResponseDataCopyWithImpl<$Res,
        $Val extends ContactChangeResponseData>
    implements $ContactChangeResponseDataCopyWith<$Res> {
  _$ContactChangeResponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContactChangeResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactChangeResponseDataImplCopyWith<$Res>
    implements $ContactChangeResponseDataCopyWith<$Res> {
  factory _$$ContactChangeResponseDataImplCopyWith(
          _$ContactChangeResponseDataImpl value,
          $Res Function(_$ContactChangeResponseDataImpl) then) =
      __$$ContactChangeResponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'message') String message});
}

/// @nodoc
class __$$ContactChangeResponseDataImplCopyWithImpl<$Res>
    extends _$ContactChangeResponseDataCopyWithImpl<$Res,
        _$ContactChangeResponseDataImpl>
    implements _$$ContactChangeResponseDataImplCopyWith<$Res> {
  __$$ContactChangeResponseDataImplCopyWithImpl(
      _$ContactChangeResponseDataImpl _value,
      $Res Function(_$ContactChangeResponseDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContactChangeResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ContactChangeResponseDataImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactChangeResponseDataImpl implements _ContactChangeResponseData {
  const _$ContactChangeResponseDataImpl(
      {@JsonKey(name: 'message') required this.message});

  factory _$ContactChangeResponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactChangeResponseDataImplFromJson(json);

  @override
  @JsonKey(name: 'message')
  final String message;

  @override
  String toString() {
    return 'ContactChangeResponseData(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactChangeResponseDataImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ContactChangeResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactChangeResponseDataImplCopyWith<_$ContactChangeResponseDataImpl>
      get copyWith => __$$ContactChangeResponseDataImplCopyWithImpl<
          _$ContactChangeResponseDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactChangeResponseDataImplToJson(
      this,
    );
  }
}

abstract class _ContactChangeResponseData implements ContactChangeResponseData {
  const factory _ContactChangeResponseData(
          {@JsonKey(name: 'message') required final String message}) =
      _$ContactChangeResponseDataImpl;

  factory _ContactChangeResponseData.fromJson(Map<String, dynamic> json) =
      _$ContactChangeResponseDataImpl.fromJson;

  @override
  @JsonKey(name: 'message')
  String get message;

  /// Create a copy of ContactChangeResponseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContactChangeResponseDataImplCopyWith<_$ContactChangeResponseDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
