// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'furniture_creation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FurnitureCreationModel _$FurnitureCreationModelFromJson(
    Map<String, dynamic> json) {
  return _FurnitureCreationModel.fromJson(json);
}

/// @nodoc
mixin _$FurnitureCreationModel {
  String get titre => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get prix => throw _privateConstructorUsedError;
  String get adresse => throw _privateConstructorUsedError;
  String? get ville => throw _privateConstructorUsedError;
  String? get commune => throw _privateConstructorUsedError;
  GeoJsonPoint? get position => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lng => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  String? get video => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get etat => throw _privateConstructorUsedError;
  FurnitureStatus? get status => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this FurnitureCreationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FurnitureCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FurnitureCreationModelCopyWith<FurnitureCreationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FurnitureCreationModelCopyWith<$Res> {
  factory $FurnitureCreationModelCopyWith(FurnitureCreationModel value,
          $Res Function(FurnitureCreationModel) then) =
      _$FurnitureCreationModelCopyWithImpl<$Res, FurnitureCreationModel>;
  @useResult
  $Res call(
      {String titre,
      String description,
      int prix,
      String adresse,
      String? ville,
      String? commune,
      GeoJsonPoint? position,
      double? lat,
      double? lng,
      List<String>? images,
      String? video,
      String? type,
      String? category,
      String? etat,
      FurnitureStatus? status,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$FurnitureCreationModelCopyWithImpl<$Res,
        $Val extends FurnitureCreationModel>
    implements $FurnitureCreationModelCopyWith<$Res> {
  _$FurnitureCreationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FurnitureCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? titre = null,
    Object? description = null,
    Object? prix = null,
    Object? adresse = null,
    Object? ville = freezed,
    Object? commune = freezed,
    Object? position = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? images = freezed,
    Object? video = freezed,
    Object? type = freezed,
    Object? category = freezed,
    Object? etat = freezed,
    Object? status = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      titre: null == titre
          ? _value.titre
          : titre // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      prix: null == prix
          ? _value.prix
          : prix // ignore: cast_nullable_to_non_nullable
              as int,
      adresse: null == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String,
      ville: freezed == ville
          ? _value.ville
          : ville // ignore: cast_nullable_to_non_nullable
              as String?,
      commune: freezed == commune
          ? _value.commune
          : commune // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as GeoJsonPoint?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      video: freezed == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      etat: freezed == etat
          ? _value.etat
          : etat // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FurnitureStatus?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FurnitureCreationModelImplCopyWith<$Res>
    implements $FurnitureCreationModelCopyWith<$Res> {
  factory _$$FurnitureCreationModelImplCopyWith(
          _$FurnitureCreationModelImpl value,
          $Res Function(_$FurnitureCreationModelImpl) then) =
      __$$FurnitureCreationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String titre,
      String description,
      int prix,
      String adresse,
      String? ville,
      String? commune,
      GeoJsonPoint? position,
      double? lat,
      double? lng,
      List<String>? images,
      String? video,
      String? type,
      String? category,
      String? etat,
      FurnitureStatus? status,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$FurnitureCreationModelImplCopyWithImpl<$Res>
    extends _$FurnitureCreationModelCopyWithImpl<$Res,
        _$FurnitureCreationModelImpl>
    implements _$$FurnitureCreationModelImplCopyWith<$Res> {
  __$$FurnitureCreationModelImplCopyWithImpl(
      _$FurnitureCreationModelImpl _value,
      $Res Function(_$FurnitureCreationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FurnitureCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? titre = null,
    Object? description = null,
    Object? prix = null,
    Object? adresse = null,
    Object? ville = freezed,
    Object? commune = freezed,
    Object? position = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? images = freezed,
    Object? video = freezed,
    Object? type = freezed,
    Object? category = freezed,
    Object? etat = freezed,
    Object? status = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$FurnitureCreationModelImpl(
      titre: null == titre
          ? _value.titre
          : titre // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      prix: null == prix
          ? _value.prix
          : prix // ignore: cast_nullable_to_non_nullable
              as int,
      adresse: null == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String,
      ville: freezed == ville
          ? _value.ville
          : ville // ignore: cast_nullable_to_non_nullable
              as String?,
      commune: freezed == commune
          ? _value.commune
          : commune // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as GeoJsonPoint?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      video: freezed == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      etat: freezed == etat
          ? _value.etat
          : etat // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FurnitureStatus?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FurnitureCreationModelImpl implements _FurnitureCreationModel {
  const _$FurnitureCreationModelImpl(
      {required this.titre,
      required this.description,
      required this.prix,
      required this.adresse,
      this.ville,
      this.commune,
      this.position,
      this.lat,
      this.lng,
      final List<String>? images = const [],
      this.video,
      this.type,
      this.category,
      this.etat,
      this.status = FurnitureStatus.active,
      final Map<String, dynamic>? metadata})
      : _images = images,
        _metadata = metadata;

  factory _$FurnitureCreationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FurnitureCreationModelImplFromJson(json);

  @override
  final String titre;
  @override
  final String description;
  @override
  final int prix;
  @override
  final String adresse;
  @override
  final String? ville;
  @override
  final String? commune;
  @override
  final GeoJsonPoint? position;
  @override
  final double? lat;
  @override
  final double? lng;
  final List<String>? _images;
  @override
  @JsonKey()
  List<String>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? video;
  @override
  final String? type;
  @override
  final String? category;
  @override
  final String? etat;
  @override
  @JsonKey()
  final FurnitureStatus? status;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'FurnitureCreationModel(titre: $titre, description: $description, prix: $prix, adresse: $adresse, ville: $ville, commune: $commune, position: $position, lat: $lat, lng: $lng, images: $images, video: $video, type: $type, category: $category, etat: $etat, status: $status, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FurnitureCreationModelImpl &&
            (identical(other.titre, titre) || other.titre == titre) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.prix, prix) || other.prix == prix) &&
            (identical(other.adresse, adresse) || other.adresse == adresse) &&
            (identical(other.ville, ville) || other.ville == ville) &&
            (identical(other.commune, commune) || other.commune == commune) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.video, video) || other.video == video) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.etat, etat) || other.etat == etat) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      titre,
      description,
      prix,
      adresse,
      ville,
      commune,
      position,
      lat,
      lng,
      const DeepCollectionEquality().hash(_images),
      video,
      type,
      category,
      etat,
      status,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of FurnitureCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FurnitureCreationModelImplCopyWith<_$FurnitureCreationModelImpl>
      get copyWith => __$$FurnitureCreationModelImplCopyWithImpl<
          _$FurnitureCreationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FurnitureCreationModelImplToJson(
      this,
    );
  }
}

abstract class _FurnitureCreationModel implements FurnitureCreationModel {
  const factory _FurnitureCreationModel(
      {required final String titre,
      required final String description,
      required final int prix,
      required final String adresse,
      final String? ville,
      final String? commune,
      final GeoJsonPoint? position,
      final double? lat,
      final double? lng,
      final List<String>? images,
      final String? video,
      final String? type,
      final String? category,
      final String? etat,
      final FurnitureStatus? status,
      final Map<String, dynamic>? metadata}) = _$FurnitureCreationModelImpl;

  factory _FurnitureCreationModel.fromJson(Map<String, dynamic> json) =
      _$FurnitureCreationModelImpl.fromJson;

  @override
  String get titre;
  @override
  String get description;
  @override
  int get prix;
  @override
  String get adresse;
  @override
  String? get ville;
  @override
  String? get commune;
  @override
  GeoJsonPoint? get position;
  @override
  double? get lat;
  @override
  double? get lng;
  @override
  List<String>? get images;
  @override
  String? get video;
  @override
  String? get type;
  @override
  String? get category;
  @override
  String? get etat;
  @override
  FurnitureStatus? get status;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of FurnitureCreationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FurnitureCreationModelImplCopyWith<_$FurnitureCreationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
