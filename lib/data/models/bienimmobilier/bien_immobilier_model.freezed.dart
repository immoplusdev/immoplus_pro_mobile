// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bien_immobilier_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BienImmobilierModel _$BienImmobilierModelFromJson(Map<String, dynamic> json) {
  return _BienImmobilierModel.fromJson(json);
}

/// @nodoc
mixin _$BienImmobilierModel {
  String get id => throw _privateConstructorUsedError;
  String get nom => throw _privateConstructorUsedError;
  String get typeBienImmobilier => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<CommoditeModel> get amentities => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  String get adresse => throw _privateConstructorUsedError;
  PositionModel get position => throw _privateConstructorUsedError;
  String get statusValidation => throw _privateConstructorUsedError;
  int get prix => throw _privateConstructorUsedError;
  bool get featured => throw _privateConstructorUsedError;
  bool get bienImmobilierDisponible => throw _privateConstructorUsedError;
  int get nombreMaxOccupants => throw _privateConstructorUsedError;
  bool get animauxAutorises => throw _privateConstructorUsedError;
  bool get fetesAutorises => throw _privateConstructorUsedError;
  String get reglesSupplementaires => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String get miniatureId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BienImmobilierModelCopyWith<BienImmobilierModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BienImmobilierModelCopyWith<$Res> {
  factory $BienImmobilierModelCopyWith(
          BienImmobilierModel value, $Res Function(BienImmobilierModel) then) =
      _$BienImmobilierModelCopyWithImpl<$Res, BienImmobilierModel>;
  @useResult
  $Res call(
      {String id,
      String nom,
      String typeBienImmobilier,
      String description,
      List<CommoditeModel> amentities,
      List<String> tags,
      List<String> images,
      String adresse,
      PositionModel position,
      String statusValidation,
      int prix,
      bool featured,
      bool bienImmobilierDisponible,
      int nombreMaxOccupants,
      bool animauxAutorises,
      bool fetesAutorises,
      String reglesSupplementaires,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      String miniatureId});

  $PositionModelCopyWith<$Res> get position;
}

/// @nodoc
class _$BienImmobilierModelCopyWithImpl<$Res, $Val extends BienImmobilierModel>
    implements $BienImmobilierModelCopyWith<$Res> {
  _$BienImmobilierModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? typeBienImmobilier = null,
    Object? description = null,
    Object? amentities = null,
    Object? tags = null,
    Object? images = null,
    Object? adresse = null,
    Object? position = null,
    Object? statusValidation = null,
    Object? prix = null,
    Object? featured = null,
    Object? bienImmobilierDisponible = null,
    Object? nombreMaxOccupants = null,
    Object? animauxAutorises = null,
    Object? fetesAutorises = null,
    Object? reglesSupplementaires = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? miniatureId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nom: null == nom
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String,
      typeBienImmobilier: null == typeBienImmobilier
          ? _value.typeBienImmobilier
          : typeBienImmobilier // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amentities: null == amentities
          ? _value.amentities
          : amentities // ignore: cast_nullable_to_non_nullable
              as List<CommoditeModel>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adresse: null == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PositionModel,
      statusValidation: null == statusValidation
          ? _value.statusValidation
          : statusValidation // ignore: cast_nullable_to_non_nullable
              as String,
      prix: null == prix
          ? _value.prix
          : prix // ignore: cast_nullable_to_non_nullable
              as int,
      featured: null == featured
          ? _value.featured
          : featured // ignore: cast_nullable_to_non_nullable
              as bool,
      bienImmobilierDisponible: null == bienImmobilierDisponible
          ? _value.bienImmobilierDisponible
          : bienImmobilierDisponible // ignore: cast_nullable_to_non_nullable
              as bool,
      nombreMaxOccupants: null == nombreMaxOccupants
          ? _value.nombreMaxOccupants
          : nombreMaxOccupants // ignore: cast_nullable_to_non_nullable
              as int,
      animauxAutorises: null == animauxAutorises
          ? _value.animauxAutorises
          : animauxAutorises // ignore: cast_nullable_to_non_nullable
              as bool,
      fetesAutorises: null == fetesAutorises
          ? _value.fetesAutorises
          : fetesAutorises // ignore: cast_nullable_to_non_nullable
              as bool,
      reglesSupplementaires: null == reglesSupplementaires
          ? _value.reglesSupplementaires
          : reglesSupplementaires // ignore: cast_nullable_to_non_nullable
              as String,
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
      miniatureId: null == miniatureId
          ? _value.miniatureId
          : miniatureId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PositionModelCopyWith<$Res> get position {
    return $PositionModelCopyWith<$Res>(_value.position, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BienImmobilierModelImplCopyWith<$Res>
    implements $BienImmobilierModelCopyWith<$Res> {
  factory _$$BienImmobilierModelImplCopyWith(_$BienImmobilierModelImpl value,
          $Res Function(_$BienImmobilierModelImpl) then) =
      __$$BienImmobilierModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nom,
      String typeBienImmobilier,
      String description,
      List<CommoditeModel> amentities,
      List<String> tags,
      List<String> images,
      String adresse,
      PositionModel position,
      String statusValidation,
      int prix,
      bool featured,
      bool bienImmobilierDisponible,
      int nombreMaxOccupants,
      bool animauxAutorises,
      bool fetesAutorises,
      String reglesSupplementaires,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      String miniatureId});

  @override
  $PositionModelCopyWith<$Res> get position;
}

/// @nodoc
class __$$BienImmobilierModelImplCopyWithImpl<$Res>
    extends _$BienImmobilierModelCopyWithImpl<$Res, _$BienImmobilierModelImpl>
    implements _$$BienImmobilierModelImplCopyWith<$Res> {
  __$$BienImmobilierModelImplCopyWithImpl(_$BienImmobilierModelImpl _value,
      $Res Function(_$BienImmobilierModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nom = null,
    Object? typeBienImmobilier = null,
    Object? description = null,
    Object? amentities = null,
    Object? tags = null,
    Object? images = null,
    Object? adresse = null,
    Object? position = null,
    Object? statusValidation = null,
    Object? prix = null,
    Object? featured = null,
    Object? bienImmobilierDisponible = null,
    Object? nombreMaxOccupants = null,
    Object? animauxAutorises = null,
    Object? fetesAutorises = null,
    Object? reglesSupplementaires = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? miniatureId = null,
  }) {
    return _then(_$BienImmobilierModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nom: null == nom
          ? _value.nom
          : nom // ignore: cast_nullable_to_non_nullable
              as String,
      typeBienImmobilier: null == typeBienImmobilier
          ? _value.typeBienImmobilier
          : typeBienImmobilier // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amentities: null == amentities
          ? _value._amentities
          : amentities // ignore: cast_nullable_to_non_nullable
              as List<CommoditeModel>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adresse: null == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as PositionModel,
      statusValidation: null == statusValidation
          ? _value.statusValidation
          : statusValidation // ignore: cast_nullable_to_non_nullable
              as String,
      prix: null == prix
          ? _value.prix
          : prix // ignore: cast_nullable_to_non_nullable
              as int,
      featured: null == featured
          ? _value.featured
          : featured // ignore: cast_nullable_to_non_nullable
              as bool,
      bienImmobilierDisponible: null == bienImmobilierDisponible
          ? _value.bienImmobilierDisponible
          : bienImmobilierDisponible // ignore: cast_nullable_to_non_nullable
              as bool,
      nombreMaxOccupants: null == nombreMaxOccupants
          ? _value.nombreMaxOccupants
          : nombreMaxOccupants // ignore: cast_nullable_to_non_nullable
              as int,
      animauxAutorises: null == animauxAutorises
          ? _value.animauxAutorises
          : animauxAutorises // ignore: cast_nullable_to_non_nullable
              as bool,
      fetesAutorises: null == fetesAutorises
          ? _value.fetesAutorises
          : fetesAutorises // ignore: cast_nullable_to_non_nullable
              as bool,
      reglesSupplementaires: null == reglesSupplementaires
          ? _value.reglesSupplementaires
          : reglesSupplementaires // ignore: cast_nullable_to_non_nullable
              as String,
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
      miniatureId: null == miniatureId
          ? _value.miniatureId
          : miniatureId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BienImmobilierModelImpl implements _BienImmobilierModel {
  _$BienImmobilierModelImpl(
      {this.id = '',
      this.nom = 'Unknown Name',
      this.typeBienImmobilier = 'Unknown Type',
      this.description = 'No Description',
      final List<CommoditeModel> amentities = const [],
      final List<String> tags = const [],
      final List<String> images = const [],
      this.adresse = 'Unknown Address',
      this.position = const PositionModel(),
      this.statusValidation = 'pending_validation',
      this.prix = 0,
      this.featured = false,
      this.bienImmobilierDisponible = true,
      this.nombreMaxOccupants = 1,
      this.animauxAutorises = false,
      this.fetesAutorises = false,
      this.reglesSupplementaires = 'No Additional Rules',
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.miniatureId = ''})
      : _amentities = amentities,
        _tags = tags,
        _images = images;

  factory _$BienImmobilierModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BienImmobilierModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String nom;
  @override
  @JsonKey()
  final String typeBienImmobilier;
  @override
  @JsonKey()
  final String description;
  final List<CommoditeModel> _amentities;
  @override
  @JsonKey()
  List<CommoditeModel> get amentities {
    if (_amentities is EqualUnmodifiableListView) return _amentities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amentities);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey()
  final String adresse;
  @override
  @JsonKey()
  final PositionModel position;
  @override
  @JsonKey()
  final String statusValidation;
  @override
  @JsonKey()
  final int prix;
  @override
  @JsonKey()
  final bool featured;
  @override
  @JsonKey()
  final bool bienImmobilierDisponible;
  @override
  @JsonKey()
  final int nombreMaxOccupants;
  @override
  @JsonKey()
  final bool animauxAutorises;
  @override
  @JsonKey()
  final bool fetesAutorises;
  @override
  @JsonKey()
  final String reglesSupplementaires;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  @JsonKey()
  final String miniatureId;

  @override
  String toString() {
    return 'BienImmobilierModel(id: $id, nom: $nom, typeBienImmobilier: $typeBienImmobilier, description: $description, amentities: $amentities, tags: $tags, images: $images, adresse: $adresse, position: $position, statusValidation: $statusValidation, prix: $prix, featured: $featured, bienImmobilierDisponible: $bienImmobilierDisponible, nombreMaxOccupants: $nombreMaxOccupants, animauxAutorises: $animauxAutorises, fetesAutorises: $fetesAutorises, reglesSupplementaires: $reglesSupplementaires, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, miniatureId: $miniatureId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BienImmobilierModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nom, nom) || other.nom == nom) &&
            (identical(other.typeBienImmobilier, typeBienImmobilier) ||
                other.typeBienImmobilier == typeBienImmobilier) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._amentities, _amentities) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.adresse, adresse) || other.adresse == adresse) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.statusValidation, statusValidation) ||
                other.statusValidation == statusValidation) &&
            (identical(other.prix, prix) || other.prix == prix) &&
            (identical(other.featured, featured) ||
                other.featured == featured) &&
            (identical(
                    other.bienImmobilierDisponible, bienImmobilierDisponible) ||
                other.bienImmobilierDisponible == bienImmobilierDisponible) &&
            (identical(other.nombreMaxOccupants, nombreMaxOccupants) ||
                other.nombreMaxOccupants == nombreMaxOccupants) &&
            (identical(other.animauxAutorises, animauxAutorises) ||
                other.animauxAutorises == animauxAutorises) &&
            (identical(other.fetesAutorises, fetesAutorises) ||
                other.fetesAutorises == fetesAutorises) &&
            (identical(other.reglesSupplementaires, reglesSupplementaires) ||
                other.reglesSupplementaires == reglesSupplementaires) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.miniatureId, miniatureId) ||
                other.miniatureId == miniatureId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        nom,
        typeBienImmobilier,
        description,
        const DeepCollectionEquality().hash(_amentities),
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_images),
        adresse,
        position,
        statusValidation,
        prix,
        featured,
        bienImmobilierDisponible,
        nombreMaxOccupants,
        animauxAutorises,
        fetesAutorises,
        reglesSupplementaires,
        createdAt,
        updatedAt,
        deletedAt,
        miniatureId
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BienImmobilierModelImplCopyWith<_$BienImmobilierModelImpl> get copyWith =>
      __$$BienImmobilierModelImplCopyWithImpl<_$BienImmobilierModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BienImmobilierModelImplToJson(
      this,
    );
  }
}

abstract class _BienImmobilierModel implements BienImmobilierModel {
  factory _BienImmobilierModel(
      {final String id,
      final String nom,
      final String typeBienImmobilier,
      final String description,
      final List<CommoditeModel> amentities,
      final List<String> tags,
      final List<String> images,
      final String adresse,
      final PositionModel position,
      final String statusValidation,
      final int prix,
      final bool featured,
      final bool bienImmobilierDisponible,
      final int nombreMaxOccupants,
      final bool animauxAutorises,
      final bool fetesAutorises,
      final String reglesSupplementaires,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final DateTime? deletedAt,
      final String miniatureId}) = _$BienImmobilierModelImpl;

  factory _BienImmobilierModel.fromJson(Map<String, dynamic> json) =
      _$BienImmobilierModelImpl.fromJson;

  @override
  String get id;
  @override
  String get nom;
  @override
  String get typeBienImmobilier;
  @override
  String get description;
  @override
  List<CommoditeModel> get amentities;
  @override
  List<String> get tags;
  @override
  List<String> get images;
  @override
  String get adresse;
  @override
  PositionModel get position;
  @override
  String get statusValidation;
  @override
  int get prix;
  @override
  bool get featured;
  @override
  bool get bienImmobilierDisponible;
  @override
  int get nombreMaxOccupants;
  @override
  bool get animauxAutorises;
  @override
  bool get fetesAutorises;
  @override
  String get reglesSupplementaires;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get deletedAt;
  @override
  String get miniatureId;
  @override
  @JsonKey(ignore: true)
  _$$BienImmobilierModelImplCopyWith<_$BienImmobilierModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
