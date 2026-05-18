// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banners_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BannersState _$BannersStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'initial':
      return BANNERS_INITIAL.fromJson(json);
    case 'loading':
      return BANNERS_LOADING.fromJson(json);
    case 'error':
      return BANNERS_ERROR.fromJson(json);
    case 'success':
      return BANNERS_SUCCESS.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'BannersState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$BannersState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(List<BannerModel> banners) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(List<BannerModel> banners)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(List<BannerModel> banners)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BANNERS_INITIAL value) initial,
    required TResult Function(BANNERS_LOADING value) loading,
    required TResult Function(BANNERS_ERROR value) error,
    required TResult Function(BANNERS_SUCCESS value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BANNERS_INITIAL value)? initial,
    TResult? Function(BANNERS_LOADING value)? loading,
    TResult? Function(BANNERS_ERROR value)? error,
    TResult? Function(BANNERS_SUCCESS value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BANNERS_INITIAL value)? initial,
    TResult Function(BANNERS_LOADING value)? loading,
    TResult Function(BANNERS_ERROR value)? error,
    TResult Function(BANNERS_SUCCESS value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this BannersState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BannersStateCopyWith<$Res> {
  factory $BannersStateCopyWith(
          BannersState value, $Res Function(BannersState) then) =
      _$BannersStateCopyWithImpl<$Res, BannersState>;
}

/// @nodoc
class _$BannersStateCopyWithImpl<$Res, $Val extends BannersState>
    implements $BannersStateCopyWith<$Res> {
  _$BannersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BannersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BANNERS_INITIALImplCopyWith<$Res> {
  factory _$$BANNERS_INITIALImplCopyWith(_$BANNERS_INITIALImpl value,
          $Res Function(_$BANNERS_INITIALImpl) then) =
      __$$BANNERS_INITIALImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BANNERS_INITIALImplCopyWithImpl<$Res>
    extends _$BannersStateCopyWithImpl<$Res, _$BANNERS_INITIALImpl>
    implements _$$BANNERS_INITIALImplCopyWith<$Res> {
  __$$BANNERS_INITIALImplCopyWithImpl(
      _$BANNERS_INITIALImpl _value, $Res Function(_$BANNERS_INITIALImpl) _then)
      : super(_value, _then);

  /// Create a copy of BannersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$BANNERS_INITIALImpl implements BANNERS_INITIAL {
  const _$BANNERS_INITIALImpl({final String? $type})
      : $type = $type ?? 'initial';

  factory _$BANNERS_INITIALImpl.fromJson(Map<String, dynamic> json) =>
      _$$BANNERS_INITIALImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BannersState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BANNERS_INITIALImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(List<BannerModel> banners) success,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(List<BannerModel> banners)? success,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(List<BannerModel> banners)? success,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BANNERS_INITIAL value) initial,
    required TResult Function(BANNERS_LOADING value) loading,
    required TResult Function(BANNERS_ERROR value) error,
    required TResult Function(BANNERS_SUCCESS value) success,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BANNERS_INITIAL value)? initial,
    TResult? Function(BANNERS_LOADING value)? loading,
    TResult? Function(BANNERS_ERROR value)? error,
    TResult? Function(BANNERS_SUCCESS value)? success,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BANNERS_INITIAL value)? initial,
    TResult Function(BANNERS_LOADING value)? loading,
    TResult Function(BANNERS_ERROR value)? error,
    TResult Function(BANNERS_SUCCESS value)? success,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BANNERS_INITIALImplToJson(
      this,
    );
  }
}

abstract class BANNERS_INITIAL implements BannersState {
  const factory BANNERS_INITIAL() = _$BANNERS_INITIALImpl;

  factory BANNERS_INITIAL.fromJson(Map<String, dynamic> json) =
      _$BANNERS_INITIALImpl.fromJson;
}

/// @nodoc
abstract class _$$BANNERS_LOADINGImplCopyWith<$Res> {
  factory _$$BANNERS_LOADINGImplCopyWith(_$BANNERS_LOADINGImpl value,
          $Res Function(_$BANNERS_LOADINGImpl) then) =
      __$$BANNERS_LOADINGImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BANNERS_LOADINGImplCopyWithImpl<$Res>
    extends _$BannersStateCopyWithImpl<$Res, _$BANNERS_LOADINGImpl>
    implements _$$BANNERS_LOADINGImplCopyWith<$Res> {
  __$$BANNERS_LOADINGImplCopyWithImpl(
      _$BANNERS_LOADINGImpl _value, $Res Function(_$BANNERS_LOADINGImpl) _then)
      : super(_value, _then);

  /// Create a copy of BannersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$BANNERS_LOADINGImpl implements BANNERS_LOADING {
  const _$BANNERS_LOADINGImpl({final String? $type})
      : $type = $type ?? 'loading';

  factory _$BANNERS_LOADINGImpl.fromJson(Map<String, dynamic> json) =>
      _$$BANNERS_LOADINGImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BannersState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BANNERS_LOADINGImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(List<BannerModel> banners) success,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(List<BannerModel> banners)? success,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(List<BannerModel> banners)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BANNERS_INITIAL value) initial,
    required TResult Function(BANNERS_LOADING value) loading,
    required TResult Function(BANNERS_ERROR value) error,
    required TResult Function(BANNERS_SUCCESS value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BANNERS_INITIAL value)? initial,
    TResult? Function(BANNERS_LOADING value)? loading,
    TResult? Function(BANNERS_ERROR value)? error,
    TResult? Function(BANNERS_SUCCESS value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BANNERS_INITIAL value)? initial,
    TResult Function(BANNERS_LOADING value)? loading,
    TResult Function(BANNERS_ERROR value)? error,
    TResult Function(BANNERS_SUCCESS value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BANNERS_LOADINGImplToJson(
      this,
    );
  }
}

abstract class BANNERS_LOADING implements BannersState {
  const factory BANNERS_LOADING() = _$BANNERS_LOADINGImpl;

  factory BANNERS_LOADING.fromJson(Map<String, dynamic> json) =
      _$BANNERS_LOADINGImpl.fromJson;
}

/// @nodoc
abstract class _$$BANNERS_ERRORImplCopyWith<$Res> {
  factory _$$BANNERS_ERRORImplCopyWith(
          _$BANNERS_ERRORImpl value, $Res Function(_$BANNERS_ERRORImpl) then) =
      __$$BANNERS_ERRORImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$BANNERS_ERRORImplCopyWithImpl<$Res>
    extends _$BannersStateCopyWithImpl<$Res, _$BANNERS_ERRORImpl>
    implements _$$BANNERS_ERRORImplCopyWith<$Res> {
  __$$BANNERS_ERRORImplCopyWithImpl(
      _$BANNERS_ERRORImpl _value, $Res Function(_$BANNERS_ERRORImpl) _then)
      : super(_value, _then);

  /// Create a copy of BannersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$BANNERS_ERRORImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BANNERS_ERRORImpl implements BANNERS_ERROR {
  const _$BANNERS_ERRORImpl({required this.message, final String? $type})
      : $type = $type ?? 'error';

  factory _$BANNERS_ERRORImpl.fromJson(Map<String, dynamic> json) =>
      _$$BANNERS_ERRORImplFromJson(json);

  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BannersState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BANNERS_ERRORImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of BannersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BANNERS_ERRORImplCopyWith<_$BANNERS_ERRORImpl> get copyWith =>
      __$$BANNERS_ERRORImplCopyWithImpl<_$BANNERS_ERRORImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(List<BannerModel> banners) success,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(List<BannerModel> banners)? success,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(List<BannerModel> banners)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BANNERS_INITIAL value) initial,
    required TResult Function(BANNERS_LOADING value) loading,
    required TResult Function(BANNERS_ERROR value) error,
    required TResult Function(BANNERS_SUCCESS value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BANNERS_INITIAL value)? initial,
    TResult? Function(BANNERS_LOADING value)? loading,
    TResult? Function(BANNERS_ERROR value)? error,
    TResult? Function(BANNERS_SUCCESS value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BANNERS_INITIAL value)? initial,
    TResult Function(BANNERS_LOADING value)? loading,
    TResult Function(BANNERS_ERROR value)? error,
    TResult Function(BANNERS_SUCCESS value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BANNERS_ERRORImplToJson(
      this,
    );
  }
}

abstract class BANNERS_ERROR implements BannersState {
  const factory BANNERS_ERROR({required final String message}) =
      _$BANNERS_ERRORImpl;

  factory BANNERS_ERROR.fromJson(Map<String, dynamic> json) =
      _$BANNERS_ERRORImpl.fromJson;

  String get message;

  /// Create a copy of BannersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BANNERS_ERRORImplCopyWith<_$BANNERS_ERRORImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BANNERS_SUCCESSImplCopyWith<$Res> {
  factory _$$BANNERS_SUCCESSImplCopyWith(_$BANNERS_SUCCESSImpl value,
          $Res Function(_$BANNERS_SUCCESSImpl) then) =
      __$$BANNERS_SUCCESSImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<BannerModel> banners});
}

/// @nodoc
class __$$BANNERS_SUCCESSImplCopyWithImpl<$Res>
    extends _$BannersStateCopyWithImpl<$Res, _$BANNERS_SUCCESSImpl>
    implements _$$BANNERS_SUCCESSImplCopyWith<$Res> {
  __$$BANNERS_SUCCESSImplCopyWithImpl(
      _$BANNERS_SUCCESSImpl _value, $Res Function(_$BANNERS_SUCCESSImpl) _then)
      : super(_value, _then);

  /// Create a copy of BannersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? banners = null,
  }) {
    return _then(_$BANNERS_SUCCESSImpl(
      banners: null == banners
          ? _value._banners
          : banners // ignore: cast_nullable_to_non_nullable
              as List<BannerModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BANNERS_SUCCESSImpl implements BANNERS_SUCCESS {
  const _$BANNERS_SUCCESSImpl(
      {required final List<BannerModel> banners, final String? $type})
      : _banners = banners,
        $type = $type ?? 'success';

  factory _$BANNERS_SUCCESSImpl.fromJson(Map<String, dynamic> json) =>
      _$$BANNERS_SUCCESSImplFromJson(json);

  final List<BannerModel> _banners;
  @override
  List<BannerModel> get banners {
    if (_banners is EqualUnmodifiableListView) return _banners;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_banners);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BannersState.success(banners: $banners)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BANNERS_SUCCESSImpl &&
            const DeepCollectionEquality().equals(other._banners, _banners));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_banners));

  /// Create a copy of BannersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BANNERS_SUCCESSImplCopyWith<_$BANNERS_SUCCESSImpl> get copyWith =>
      __$$BANNERS_SUCCESSImplCopyWithImpl<_$BANNERS_SUCCESSImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(List<BannerModel> banners) success,
  }) {
    return success(banners);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(List<BannerModel> banners)? success,
  }) {
    return success?.call(banners);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(List<BannerModel> banners)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(banners);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BANNERS_INITIAL value) initial,
    required TResult Function(BANNERS_LOADING value) loading,
    required TResult Function(BANNERS_ERROR value) error,
    required TResult Function(BANNERS_SUCCESS value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BANNERS_INITIAL value)? initial,
    TResult? Function(BANNERS_LOADING value)? loading,
    TResult? Function(BANNERS_ERROR value)? error,
    TResult? Function(BANNERS_SUCCESS value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BANNERS_INITIAL value)? initial,
    TResult Function(BANNERS_LOADING value)? loading,
    TResult Function(BANNERS_ERROR value)? error,
    TResult Function(BANNERS_SUCCESS value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BANNERS_SUCCESSImplToJson(
      this,
    );
  }
}

abstract class BANNERS_SUCCESS implements BannersState {
  const factory BANNERS_SUCCESS({required final List<BannerModel> banners}) =
      _$BANNERS_SUCCESSImpl;

  factory BANNERS_SUCCESS.fromJson(Map<String, dynamic> json) =
      _$BANNERS_SUCCESSImpl.fromJson;

  List<BannerModel> get banners;

  /// Create a copy of BannersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BANNERS_SUCCESSImplCopyWith<_$BANNERS_SUCCESSImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
