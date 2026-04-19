// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'furniture_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FurnitureModel _$FurnitureModelFromJson(Map<String, dynamic> json) {
  return _FurnitureModel.fromJson(json);
}

/// @nodoc
mixin _$FurnitureModel {
  String get id => throw _privateConstructorUsedError;
  String get owner => throw _privateConstructorUsedError;
  String get titre => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get adresse => throw _privateConstructorUsedError;
  int get prix => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get ville => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get commune => throw _privateConstructorUsedError;
  GeoJsonPoint? get position => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lng => throw _privateConstructorUsedError;
  List<String>? get images => throw _privateConstructorUsedError;
  String? get video => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get etat => throw _privateConstructorUsedError;
  int get viewsCount => throw _privateConstructorUsedError;
  FurnitureStatus get status => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;

  /// Serializes this FurnitureModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FurnitureModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FurnitureModelCopyWith<FurnitureModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FurnitureModelCopyWith<$Res> {
  factory $FurnitureModelCopyWith(
          FurnitureModel value, $Res Function(FurnitureModel) then) =
      _$FurnitureModelCopyWithImpl<$Res, FurnitureModel>;
  @useResult
  $Res call(
      {String id,
      String owner,
      String titre,
      String description,
      String adresse,
      int prix,
      @JsonKey(includeIfNull: false) String? ville,
      @JsonKey(includeIfNull: false) String? commune,
      GeoJsonPoint? position,
      double? lat,
      double? lng,
      List<String>? images,
      String? video,
      String? type,
      String? category,
      String? etat,
      int viewsCount,
      FurnitureStatus status,
      Map<String, dynamic>? metadata,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy});
}

/// @nodoc
class _$FurnitureModelCopyWithImpl<$Res, $Val extends FurnitureModel>
    implements $FurnitureModelCopyWith<$Res> {
  _$FurnitureModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FurnitureModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? owner = null,
    Object? titre = null,
    Object? description = null,
    Object? adresse = null,
    Object? prix = null,
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
    Object? viewsCount = null,
    Object? status = null,
    Object? metadata = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      titre: null == titre
          ? _value.titre
          : titre // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      adresse: null == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String,
      prix: null == prix
          ? _value.prix
          : prix // ignore: cast_nullable_to_non_nullable
              as int,
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
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FurnitureStatus,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FurnitureModelImplCopyWith<$Res>
    implements $FurnitureModelCopyWith<$Res> {
  factory _$$FurnitureModelImplCopyWith(_$FurnitureModelImpl value,
          $Res Function(_$FurnitureModelImpl) then) =
      __$$FurnitureModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String owner,
      String titre,
      String description,
      String adresse,
      int prix,
      @JsonKey(includeIfNull: false) String? ville,
      @JsonKey(includeIfNull: false) String? commune,
      GeoJsonPoint? position,
      double? lat,
      double? lng,
      List<String>? images,
      String? video,
      String? type,
      String? category,
      String? etat,
      int viewsCount,
      FurnitureStatus status,
      Map<String, dynamic>? metadata,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy});
}

/// @nodoc
class __$$FurnitureModelImplCopyWithImpl<$Res>
    extends _$FurnitureModelCopyWithImpl<$Res, _$FurnitureModelImpl>
    implements _$$FurnitureModelImplCopyWith<$Res> {
  __$$FurnitureModelImplCopyWithImpl(
      _$FurnitureModelImpl _value, $Res Function(_$FurnitureModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FurnitureModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? owner = null,
    Object? titre = null,
    Object? description = null,
    Object? adresse = null,
    Object? prix = null,
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
    Object? viewsCount = null,
    Object? status = null,
    Object? metadata = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_$FurnitureModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as String,
      titre: null == titre
          ? _value.titre
          : titre // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      adresse: null == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String,
      prix: null == prix
          ? _value.prix
          : prix // ignore: cast_nullable_to_non_nullable
              as int,
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
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FurnitureStatus,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FurnitureModelImpl implements _FurnitureModel {
  _$FurnitureModelImpl(
      {required this.id,
      required this.owner,
      required this.titre,
      required this.description,
      required this.adresse,
      required this.prix,
      @JsonKey(includeIfNull: false) this.ville,
      @JsonKey(includeIfNull: false) this.commune,
      this.position,
      this.lat,
      this.lng,
      final List<String>? images = const [],
      this.video,
      this.type,
      this.category,
      this.etat,
      this.viewsCount = 0,
      this.status = FurnitureStatus.active,
      final Map<String, dynamic>? metadata,
      this.createdAt,
      this.updatedAt,
      this.createdBy})
      : _images = images,
        _metadata = metadata;

  factory _$FurnitureModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FurnitureModelImplFromJson(json);

  @override
  final String id;
  @override
  final String owner;
  @override
  final String titre;
  @override
  final String description;
  @override
  final String adresse;
  @override
  final int prix;
  @override
  @JsonKey(includeIfNull: false)
  final String? ville;
  @override
  @JsonKey(includeIfNull: false)
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
  final int viewsCount;
  @override
  @JsonKey()
  final FurnitureStatus status;
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
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? createdBy;

  @override
  String toString() {
    return 'FurnitureModel(id: $id, owner: $owner, titre: $titre, description: $description, adresse: $adresse, prix: $prix, ville: $ville, commune: $commune, position: $position, lat: $lat, lng: $lng, images: $images, video: $video, type: $type, category: $category, etat: $etat, viewsCount: $viewsCount, status: $status, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FurnitureModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.titre, titre) || other.titre == titre) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.adresse, adresse) || other.adresse == adresse) &&
            (identical(other.prix, prix) || other.prix == prix) &&
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
            (identical(other.viewsCount, viewsCount) ||
                other.viewsCount == viewsCount) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        owner,
        titre,
        description,
        adresse,
        prix,
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
        viewsCount,
        status,
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt,
        createdBy
      ]);

  /// Create a copy of FurnitureModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FurnitureModelImplCopyWith<_$FurnitureModelImpl> get copyWith =>
      __$$FurnitureModelImplCopyWithImpl<_$FurnitureModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FurnitureModelImplToJson(
      this,
    );
  }
}

abstract class _FurnitureModel implements FurnitureModel {
  factory _FurnitureModel(
      {required final String id,
      required final String owner,
      required final String titre,
      required final String description,
      required final String adresse,
      required final int prix,
      @JsonKey(includeIfNull: false) final String? ville,
      @JsonKey(includeIfNull: false) final String? commune,
      final GeoJsonPoint? position,
      final double? lat,
      final double? lng,
      final List<String>? images,
      final String? video,
      final String? type,
      final String? category,
      final String? etat,
      final int viewsCount,
      final FurnitureStatus status,
      final Map<String, dynamic>? metadata,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? createdBy}) = _$FurnitureModelImpl;

  factory _FurnitureModel.fromJson(Map<String, dynamic> json) =
      _$FurnitureModelImpl.fromJson;

  @override
  String get id;
  @override
  String get owner;
  @override
  String get titre;
  @override
  String get description;
  @override
  String get adresse;
  @override
  int get prix;
  @override
  @JsonKey(includeIfNull: false)
  String? get ville;
  @override
  @JsonKey(includeIfNull: false)
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
  int get viewsCount;
  @override
  FurnitureStatus get status;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;

  /// Create a copy of FurnitureModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FurnitureModelImplCopyWith<_$FurnitureModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
