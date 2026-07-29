// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_additional_data_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateAdditionalDataResponseModel _$UpdateAdditionalDataResponseModelFromJson(
    Map<String, dynamic> json) {
  return _UpdateAdditionalDataResponseModel.fromJson(json);
}

/// @nodoc
mixin _$UpdateAdditionalDataResponseModel {
  UpdateAdditionalDataResult get data => throw _privateConstructorUsedError;

  /// Serializes this UpdateAdditionalDataResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateAdditionalDataResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateAdditionalDataResponseModelCopyWith<UpdateAdditionalDataResponseModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateAdditionalDataResponseModelCopyWith<$Res> {
  factory $UpdateAdditionalDataResponseModelCopyWith(
          UpdateAdditionalDataResponseModel value,
          $Res Function(UpdateAdditionalDataResponseModel) then) =
      _$UpdateAdditionalDataResponseModelCopyWithImpl<$Res,
          UpdateAdditionalDataResponseModel>;
  @useResult
  $Res call({UpdateAdditionalDataResult data});

  $UpdateAdditionalDataResultCopyWith<$Res> get data;
}

/// @nodoc
class _$UpdateAdditionalDataResponseModelCopyWithImpl<$Res,
        $Val extends UpdateAdditionalDataResponseModel>
    implements $UpdateAdditionalDataResponseModelCopyWith<$Res> {
  _$UpdateAdditionalDataResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateAdditionalDataResponseModel
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
              as UpdateAdditionalDataResult,
    ) as $Val);
  }

  /// Create a copy of UpdateAdditionalDataResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UpdateAdditionalDataResultCopyWith<$Res> get data {
    return $UpdateAdditionalDataResultCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UpdateAdditionalDataResponseModelImplCopyWith<$Res>
    implements $UpdateAdditionalDataResponseModelCopyWith<$Res> {
  factory _$$UpdateAdditionalDataResponseModelImplCopyWith(
          _$UpdateAdditionalDataResponseModelImpl value,
          $Res Function(_$UpdateAdditionalDataResponseModelImpl) then) =
      __$$UpdateAdditionalDataResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UpdateAdditionalDataResult data});

  @override
  $UpdateAdditionalDataResultCopyWith<$Res> get data;
}

/// @nodoc
class __$$UpdateAdditionalDataResponseModelImplCopyWithImpl<$Res>
    extends _$UpdateAdditionalDataResponseModelCopyWithImpl<$Res,
        _$UpdateAdditionalDataResponseModelImpl>
    implements _$$UpdateAdditionalDataResponseModelImplCopyWith<$Res> {
  __$$UpdateAdditionalDataResponseModelImplCopyWithImpl(
      _$UpdateAdditionalDataResponseModelImpl _value,
      $Res Function(_$UpdateAdditionalDataResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateAdditionalDataResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$UpdateAdditionalDataResponseModelImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as UpdateAdditionalDataResult,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateAdditionalDataResponseModelImpl
    implements _UpdateAdditionalDataResponseModel {
  _$UpdateAdditionalDataResponseModelImpl({required this.data});

  factory _$UpdateAdditionalDataResponseModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateAdditionalDataResponseModelImplFromJson(json);

  @override
  final UpdateAdditionalDataResult data;

  @override
  String toString() {
    return 'UpdateAdditionalDataResponseModel(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateAdditionalDataResponseModelImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of UpdateAdditionalDataResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateAdditionalDataResponseModelImplCopyWith<
          _$UpdateAdditionalDataResponseModelImpl>
      get copyWith => __$$UpdateAdditionalDataResponseModelImplCopyWithImpl<
          _$UpdateAdditionalDataResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateAdditionalDataResponseModelImplToJson(
      this,
    );
  }
}

abstract class _UpdateAdditionalDataResponseModel
    implements UpdateAdditionalDataResponseModel {
  factory _UpdateAdditionalDataResponseModel(
          {required final UpdateAdditionalDataResult data}) =
      _$UpdateAdditionalDataResponseModelImpl;

  factory _UpdateAdditionalDataResponseModel.fromJson(
          Map<String, dynamic> json) =
      _$UpdateAdditionalDataResponseModelImpl.fromJson;

  @override
  UpdateAdditionalDataResult get data;

  /// Create a copy of UpdateAdditionalDataResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateAdditionalDataResponseModelImplCopyWith<
          _$UpdateAdditionalDataResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateAdditionalDataResult _$UpdateAdditionalDataResultFromJson(
    Map<String, dynamic> json) {
  return _UpdateAdditionalDataResult.fromJson(json);
}

/// @nodoc
mixin _$UpdateAdditionalDataResult {
  String? get lieuNaissance => throw _privateConstructorUsedError;
  String? get activite => throw _privateConstructorUsedError;
  String? get photoIdentite => throw _privateConstructorUsedError;
  String? get pieceIdentite => throw _privateConstructorUsedError;
  String? get pieceIdentiteVerso => throw _privateConstructorUsedError;
  String? get nomEntreprise => throw _privateConstructorUsedError;
  String? get emailEntreprise => throw _privateConstructorUsedError;
  String? get registreCommerce => throw _privateConstructorUsedError;
  String? get numeroContribuable => throw _privateConstructorUsedError;
  String? get typeEntreprise => throw _privateConstructorUsedError;

  /// Serializes this UpdateAdditionalDataResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateAdditionalDataResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateAdditionalDataResultCopyWith<UpdateAdditionalDataResult>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateAdditionalDataResultCopyWith<$Res> {
  factory $UpdateAdditionalDataResultCopyWith(UpdateAdditionalDataResult value,
          $Res Function(UpdateAdditionalDataResult) then) =
      _$UpdateAdditionalDataResultCopyWithImpl<$Res,
          UpdateAdditionalDataResult>;
  @useResult
  $Res call(
      {String? lieuNaissance,
      String? activite,
      String? photoIdentite,
      String? pieceIdentite,
      String? pieceIdentiteVerso,
      String? nomEntreprise,
      String? emailEntreprise,
      String? registreCommerce,
      String? numeroContribuable,
      String? typeEntreprise});
}

/// @nodoc
class _$UpdateAdditionalDataResultCopyWithImpl<$Res,
        $Val extends UpdateAdditionalDataResult>
    implements $UpdateAdditionalDataResultCopyWith<$Res> {
  _$UpdateAdditionalDataResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateAdditionalDataResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lieuNaissance = freezed,
    Object? activite = freezed,
    Object? photoIdentite = freezed,
    Object? pieceIdentite = freezed,
    Object? pieceIdentiteVerso = freezed,
    Object? nomEntreprise = freezed,
    Object? emailEntreprise = freezed,
    Object? registreCommerce = freezed,
    Object? numeroContribuable = freezed,
    Object? typeEntreprise = freezed,
  }) {
    return _then(_value.copyWith(
      lieuNaissance: freezed == lieuNaissance
          ? _value.lieuNaissance
          : lieuNaissance // ignore: cast_nullable_to_non_nullable
              as String?,
      activite: freezed == activite
          ? _value.activite
          : activite // ignore: cast_nullable_to_non_nullable
              as String?,
      photoIdentite: freezed == photoIdentite
          ? _value.photoIdentite
          : photoIdentite // ignore: cast_nullable_to_non_nullable
              as String?,
      pieceIdentite: freezed == pieceIdentite
          ? _value.pieceIdentite
          : pieceIdentite // ignore: cast_nullable_to_non_nullable
              as String?,
      pieceIdentiteVerso: freezed == pieceIdentiteVerso
          ? _value.pieceIdentiteVerso
          : pieceIdentiteVerso // ignore: cast_nullable_to_non_nullable
              as String?,
      nomEntreprise: freezed == nomEntreprise
          ? _value.nomEntreprise
          : nomEntreprise // ignore: cast_nullable_to_non_nullable
              as String?,
      emailEntreprise: freezed == emailEntreprise
          ? _value.emailEntreprise
          : emailEntreprise // ignore: cast_nullable_to_non_nullable
              as String?,
      registreCommerce: freezed == registreCommerce
          ? _value.registreCommerce
          : registreCommerce // ignore: cast_nullable_to_non_nullable
              as String?,
      numeroContribuable: freezed == numeroContribuable
          ? _value.numeroContribuable
          : numeroContribuable // ignore: cast_nullable_to_non_nullable
              as String?,
      typeEntreprise: freezed == typeEntreprise
          ? _value.typeEntreprise
          : typeEntreprise // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateAdditionalDataResultImplCopyWith<$Res>
    implements $UpdateAdditionalDataResultCopyWith<$Res> {
  factory _$$UpdateAdditionalDataResultImplCopyWith(
          _$UpdateAdditionalDataResultImpl value,
          $Res Function(_$UpdateAdditionalDataResultImpl) then) =
      __$$UpdateAdditionalDataResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? lieuNaissance,
      String? activite,
      String? photoIdentite,
      String? pieceIdentite,
      String? pieceIdentiteVerso,
      String? nomEntreprise,
      String? emailEntreprise,
      String? registreCommerce,
      String? numeroContribuable,
      String? typeEntreprise});
}

/// @nodoc
class __$$UpdateAdditionalDataResultImplCopyWithImpl<$Res>
    extends _$UpdateAdditionalDataResultCopyWithImpl<$Res,
        _$UpdateAdditionalDataResultImpl>
    implements _$$UpdateAdditionalDataResultImplCopyWith<$Res> {
  __$$UpdateAdditionalDataResultImplCopyWithImpl(
      _$UpdateAdditionalDataResultImpl _value,
      $Res Function(_$UpdateAdditionalDataResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateAdditionalDataResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lieuNaissance = freezed,
    Object? activite = freezed,
    Object? photoIdentite = freezed,
    Object? pieceIdentite = freezed,
    Object? pieceIdentiteVerso = freezed,
    Object? nomEntreprise = freezed,
    Object? emailEntreprise = freezed,
    Object? registreCommerce = freezed,
    Object? numeroContribuable = freezed,
    Object? typeEntreprise = freezed,
  }) {
    return _then(_$UpdateAdditionalDataResultImpl(
      lieuNaissance: freezed == lieuNaissance
          ? _value.lieuNaissance
          : lieuNaissance // ignore: cast_nullable_to_non_nullable
              as String?,
      activite: freezed == activite
          ? _value.activite
          : activite // ignore: cast_nullable_to_non_nullable
              as String?,
      photoIdentite: freezed == photoIdentite
          ? _value.photoIdentite
          : photoIdentite // ignore: cast_nullable_to_non_nullable
              as String?,
      pieceIdentite: freezed == pieceIdentite
          ? _value.pieceIdentite
          : pieceIdentite // ignore: cast_nullable_to_non_nullable
              as String?,
      pieceIdentiteVerso: freezed == pieceIdentiteVerso
          ? _value.pieceIdentiteVerso
          : pieceIdentiteVerso // ignore: cast_nullable_to_non_nullable
              as String?,
      nomEntreprise: freezed == nomEntreprise
          ? _value.nomEntreprise
          : nomEntreprise // ignore: cast_nullable_to_non_nullable
              as String?,
      emailEntreprise: freezed == emailEntreprise
          ? _value.emailEntreprise
          : emailEntreprise // ignore: cast_nullable_to_non_nullable
              as String?,
      registreCommerce: freezed == registreCommerce
          ? _value.registreCommerce
          : registreCommerce // ignore: cast_nullable_to_non_nullable
              as String?,
      numeroContribuable: freezed == numeroContribuable
          ? _value.numeroContribuable
          : numeroContribuable // ignore: cast_nullable_to_non_nullable
              as String?,
      typeEntreprise: freezed == typeEntreprise
          ? _value.typeEntreprise
          : typeEntreprise // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateAdditionalDataResultImpl implements _UpdateAdditionalDataResult {
  const _$UpdateAdditionalDataResultImpl(
      {this.lieuNaissance,
      this.activite,
      this.photoIdentite,
      this.pieceIdentite,
      this.pieceIdentiteVerso,
      this.nomEntreprise,
      this.emailEntreprise,
      this.registreCommerce,
      this.numeroContribuable,
      this.typeEntreprise});

  factory _$UpdateAdditionalDataResultImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateAdditionalDataResultImplFromJson(json);

  @override
  final String? lieuNaissance;
  @override
  final String? activite;
  @override
  final String? photoIdentite;
  @override
  final String? pieceIdentite;
  @override
  final String? pieceIdentiteVerso;
  @override
  final String? nomEntreprise;
  @override
  final String? emailEntreprise;
  @override
  final String? registreCommerce;
  @override
  final String? numeroContribuable;
  @override
  final String? typeEntreprise;

  @override
  String toString() {
    return 'UpdateAdditionalDataResult(lieuNaissance: $lieuNaissance, activite: $activite, photoIdentite: $photoIdentite, pieceIdentite: $pieceIdentite, pieceIdentiteVerso: $pieceIdentiteVerso, nomEntreprise: $nomEntreprise, emailEntreprise: $emailEntreprise, registreCommerce: $registreCommerce, numeroContribuable: $numeroContribuable, typeEntreprise: $typeEntreprise)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateAdditionalDataResultImpl &&
            (identical(other.lieuNaissance, lieuNaissance) ||
                other.lieuNaissance == lieuNaissance) &&
            (identical(other.activite, activite) ||
                other.activite == activite) &&
            (identical(other.photoIdentite, photoIdentite) ||
                other.photoIdentite == photoIdentite) &&
            (identical(other.pieceIdentite, pieceIdentite) ||
                other.pieceIdentite == pieceIdentite) &&
            (identical(other.pieceIdentiteVerso, pieceIdentiteVerso) ||
                other.pieceIdentiteVerso == pieceIdentiteVerso) &&
            (identical(other.nomEntreprise, nomEntreprise) ||
                other.nomEntreprise == nomEntreprise) &&
            (identical(other.emailEntreprise, emailEntreprise) ||
                other.emailEntreprise == emailEntreprise) &&
            (identical(other.registreCommerce, registreCommerce) ||
                other.registreCommerce == registreCommerce) &&
            (identical(other.numeroContribuable, numeroContribuable) ||
                other.numeroContribuable == numeroContribuable) &&
            (identical(other.typeEntreprise, typeEntreprise) ||
                other.typeEntreprise == typeEntreprise));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lieuNaissance,
      activite,
      photoIdentite,
      pieceIdentite,
      pieceIdentiteVerso,
      nomEntreprise,
      emailEntreprise,
      registreCommerce,
      numeroContribuable,
      typeEntreprise);

  /// Create a copy of UpdateAdditionalDataResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateAdditionalDataResultImplCopyWith<_$UpdateAdditionalDataResultImpl>
      get copyWith => __$$UpdateAdditionalDataResultImplCopyWithImpl<
          _$UpdateAdditionalDataResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateAdditionalDataResultImplToJson(
      this,
    );
  }
}

abstract class _UpdateAdditionalDataResult
    implements UpdateAdditionalDataResult {
  const factory _UpdateAdditionalDataResult(
      {final String? lieuNaissance,
      final String? activite,
      final String? photoIdentite,
      final String? pieceIdentite,
      final String? pieceIdentiteVerso,
      final String? nomEntreprise,
      final String? emailEntreprise,
      final String? registreCommerce,
      final String? numeroContribuable,
      final String? typeEntreprise}) = _$UpdateAdditionalDataResultImpl;

  factory _UpdateAdditionalDataResult.fromJson(Map<String, dynamic> json) =
      _$UpdateAdditionalDataResultImpl.fromJson;

  @override
  String? get lieuNaissance;
  @override
  String? get activite;
  @override
  String? get photoIdentite;
  @override
  String? get pieceIdentite;
  @override
  String? get pieceIdentiteVerso;
  @override
  String? get nomEntreprise;
  @override
  String? get emailEntreprise;
  @override
  String? get registreCommerce;
  @override
  String? get numeroContribuable;
  @override
  String? get typeEntreprise;

  /// Create a copy of UpdateAdditionalDataResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateAdditionalDataResultImplCopyWith<_$UpdateAdditionalDataResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}
