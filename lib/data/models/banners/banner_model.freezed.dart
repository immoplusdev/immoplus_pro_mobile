// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BannerResponse _$BannerResponseFromJson(Map<String, dynamic> json) {
  return _BannerResponse.fromJson(json);
}

/// @nodoc
mixin _$BannerResponse {
  List<BannerModel> get data => throw _privateConstructorUsedError;

  /// Serializes this BannerResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BannerResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BannerResponseCopyWith<BannerResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BannerResponseCopyWith<$Res> {
  factory $BannerResponseCopyWith(
          BannerResponse value, $Res Function(BannerResponse) then) =
      _$BannerResponseCopyWithImpl<$Res, BannerResponse>;
  @useResult
  $Res call({List<BannerModel> data});
}

/// @nodoc
class _$BannerResponseCopyWithImpl<$Res, $Val extends BannerResponse>
    implements $BannerResponseCopyWith<$Res> {
  _$BannerResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BannerResponse
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
              as List<BannerModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BannerResponseImplCopyWith<$Res>
    implements $BannerResponseCopyWith<$Res> {
  factory _$$BannerResponseImplCopyWith(_$BannerResponseImpl value,
          $Res Function(_$BannerResponseImpl) then) =
      __$$BannerResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<BannerModel> data});
}

/// @nodoc
class __$$BannerResponseImplCopyWithImpl<$Res>
    extends _$BannerResponseCopyWithImpl<$Res, _$BannerResponseImpl>
    implements _$$BannerResponseImplCopyWith<$Res> {
  __$$BannerResponseImplCopyWithImpl(
      _$BannerResponseImpl _value, $Res Function(_$BannerResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of BannerResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$BannerResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<BannerModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BannerResponseImpl implements _BannerResponse {
  const _$BannerResponseImpl({final List<BannerModel> data = const []})
      : _data = data;

  factory _$BannerResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$BannerResponseImplFromJson(json);

  final List<BannerModel> _data;
  @override
  @JsonKey()
  List<BannerModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'BannerResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BannerResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of BannerResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BannerResponseImplCopyWith<_$BannerResponseImpl> get copyWith =>
      __$$BannerResponseImplCopyWithImpl<_$BannerResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BannerResponseImplToJson(
      this,
    );
  }
}

abstract class _BannerResponse implements BannerResponse {
  const factory _BannerResponse({final List<BannerModel> data}) =
      _$BannerResponseImpl;

  factory _BannerResponse.fromJson(Map<String, dynamic> json) =
      _$BannerResponseImpl.fromJson;

  @override
  List<BannerModel> get data;

  /// Create a copy of BannerResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BannerResponseImplCopyWith<_$BannerResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) {
  return _BannerModel.fromJson(json);
}

/// @nodoc
mixin _$BannerModel {
  int? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'cta_label')
  String? get ctaLabel => throw _privateConstructorUsedError;
  @JsonKey(name: 'cta_url')
  String? get ctaUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'cta2_label')
  String? get cta2Label => throw _privateConstructorUsedError;
  @JsonKey(name: 'cta2_url')
  String? get cta2Url => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'bg_color')
  String? get bgColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_color')
  String? get iconColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'text_color')
  String? get textColor => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get audience => throw _privateConstructorUsedError;
  int? get order => throw _privateConstructorUsedError;
  bool? get active => throw _privateConstructorUsedError;
  bool? get dismissible => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this BannerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BannerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BannerModelCopyWith<BannerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BannerModelCopyWith<$Res> {
  factory $BannerModelCopyWith(
          BannerModel value, $Res Function(BannerModel) then) =
      _$BannerModelCopyWithImpl<$Res, BannerModel>;
  @useResult
  $Res call(
      {int? id,
      String? title,
      String? subtitle,
      @JsonKey(name: 'cta_label') String? ctaLabel,
      @JsonKey(name: 'cta_url') String? ctaUrl,
      @JsonKey(name: 'cta2_label') String? cta2Label,
      @JsonKey(name: 'cta2_url') String? cta2Url,
      String? icon,
      @JsonKey(name: 'bg_color') String? bgColor,
      @JsonKey(name: 'icon_color') String? iconColor,
      @JsonKey(name: 'text_color') String? textColor,
      String? type,
      String? audience,
      int? order,
      bool? active,
      bool? dismissible,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$BannerModelCopyWithImpl<$Res, $Val extends BannerModel>
    implements $BannerModelCopyWith<$Res> {
  _$BannerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BannerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? subtitle = freezed,
    Object? ctaLabel = freezed,
    Object? ctaUrl = freezed,
    Object? cta2Label = freezed,
    Object? cta2Url = freezed,
    Object? icon = freezed,
    Object? bgColor = freezed,
    Object? iconColor = freezed,
    Object? textColor = freezed,
    Object? type = freezed,
    Object? audience = freezed,
    Object? order = freezed,
    Object? active = freezed,
    Object? dismissible = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      ctaLabel: freezed == ctaLabel
          ? _value.ctaLabel
          : ctaLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      ctaUrl: freezed == ctaUrl
          ? _value.ctaUrl
          : ctaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cta2Label: freezed == cta2Label
          ? _value.cta2Label
          : cta2Label // ignore: cast_nullable_to_non_nullable
              as String?,
      cta2Url: freezed == cta2Url
          ? _value.cta2Url
          : cta2Url // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      bgColor: freezed == bgColor
          ? _value.bgColor
          : bgColor // ignore: cast_nullable_to_non_nullable
              as String?,
      iconColor: freezed == iconColor
          ? _value.iconColor
          : iconColor // ignore: cast_nullable_to_non_nullable
              as String?,
      textColor: freezed == textColor
          ? _value.textColor
          : textColor // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      audience: freezed == audience
          ? _value.audience
          : audience // ignore: cast_nullable_to_non_nullable
              as String?,
      order: freezed == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      dismissible: freezed == dismissible
          ? _value.dismissible
          : dismissible // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BannerModelImplCopyWith<$Res>
    implements $BannerModelCopyWith<$Res> {
  factory _$$BannerModelImplCopyWith(
          _$BannerModelImpl value, $Res Function(_$BannerModelImpl) then) =
      __$$BannerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? title,
      String? subtitle,
      @JsonKey(name: 'cta_label') String? ctaLabel,
      @JsonKey(name: 'cta_url') String? ctaUrl,
      @JsonKey(name: 'cta2_label') String? cta2Label,
      @JsonKey(name: 'cta2_url') String? cta2Url,
      String? icon,
      @JsonKey(name: 'bg_color') String? bgColor,
      @JsonKey(name: 'icon_color') String? iconColor,
      @JsonKey(name: 'text_color') String? textColor,
      String? type,
      String? audience,
      int? order,
      bool? active,
      bool? dismissible,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$BannerModelImplCopyWithImpl<$Res>
    extends _$BannerModelCopyWithImpl<$Res, _$BannerModelImpl>
    implements _$$BannerModelImplCopyWith<$Res> {
  __$$BannerModelImplCopyWithImpl(
      _$BannerModelImpl _value, $Res Function(_$BannerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BannerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? subtitle = freezed,
    Object? ctaLabel = freezed,
    Object? ctaUrl = freezed,
    Object? cta2Label = freezed,
    Object? cta2Url = freezed,
    Object? icon = freezed,
    Object? bgColor = freezed,
    Object? iconColor = freezed,
    Object? textColor = freezed,
    Object? type = freezed,
    Object? audience = freezed,
    Object? order = freezed,
    Object? active = freezed,
    Object? dismissible = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$BannerModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      ctaLabel: freezed == ctaLabel
          ? _value.ctaLabel
          : ctaLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      ctaUrl: freezed == ctaUrl
          ? _value.ctaUrl
          : ctaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cta2Label: freezed == cta2Label
          ? _value.cta2Label
          : cta2Label // ignore: cast_nullable_to_non_nullable
              as String?,
      cta2Url: freezed == cta2Url
          ? _value.cta2Url
          : cta2Url // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      bgColor: freezed == bgColor
          ? _value.bgColor
          : bgColor // ignore: cast_nullable_to_non_nullable
              as String?,
      iconColor: freezed == iconColor
          ? _value.iconColor
          : iconColor // ignore: cast_nullable_to_non_nullable
              as String?,
      textColor: freezed == textColor
          ? _value.textColor
          : textColor // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      audience: freezed == audience
          ? _value.audience
          : audience // ignore: cast_nullable_to_non_nullable
              as String?,
      order: freezed == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      dismissible: freezed == dismissible
          ? _value.dismissible
          : dismissible // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BannerModelImpl implements _BannerModel {
  const _$BannerModelImpl(
      {this.id,
      this.title,
      this.subtitle,
      @JsonKey(name: 'cta_label') this.ctaLabel,
      @JsonKey(name: 'cta_url') this.ctaUrl,
      @JsonKey(name: 'cta2_label') this.cta2Label,
      @JsonKey(name: 'cta2_url') this.cta2Url,
      this.icon,
      @JsonKey(name: 'bg_color') this.bgColor,
      @JsonKey(name: 'icon_color') this.iconColor,
      @JsonKey(name: 'text_color') this.textColor,
      this.type,
      this.audience,
      this.order,
      this.active,
      this.dismissible,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$BannerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BannerModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String? title;
  @override
  final String? subtitle;
  @override
  @JsonKey(name: 'cta_label')
  final String? ctaLabel;
  @override
  @JsonKey(name: 'cta_url')
  final String? ctaUrl;
  @override
  @JsonKey(name: 'cta2_label')
  final String? cta2Label;
  @override
  @JsonKey(name: 'cta2_url')
  final String? cta2Url;
  @override
  final String? icon;
  @override
  @JsonKey(name: 'bg_color')
  final String? bgColor;
  @override
  @JsonKey(name: 'icon_color')
  final String? iconColor;
  @override
  @JsonKey(name: 'text_color')
  final String? textColor;
  @override
  final String? type;
  @override
  final String? audience;
  @override
  final int? order;
  @override
  final bool? active;
  @override
  final bool? dismissible;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
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
    return 'BannerModel(id: $id, title: $title, subtitle: $subtitle, ctaLabel: $ctaLabel, ctaUrl: $ctaUrl, cta2Label: $cta2Label, cta2Url: $cta2Url, icon: $icon, bgColor: $bgColor, iconColor: $iconColor, textColor: $textColor, type: $type, audience: $audience, order: $order, active: $active, dismissible: $dismissible, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BannerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.ctaLabel, ctaLabel) ||
                other.ctaLabel == ctaLabel) &&
            (identical(other.ctaUrl, ctaUrl) || other.ctaUrl == ctaUrl) &&
            (identical(other.cta2Label, cta2Label) ||
                other.cta2Label == cta2Label) &&
            (identical(other.cta2Url, cta2Url) || other.cta2Url == cta2Url) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.bgColor, bgColor) || other.bgColor == bgColor) &&
            (identical(other.iconColor, iconColor) ||
                other.iconColor == iconColor) &&
            (identical(other.textColor, textColor) ||
                other.textColor == textColor) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.audience, audience) ||
                other.audience == audience) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.dismissible, dismissible) ||
                other.dismissible == dismissible) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        subtitle,
        ctaLabel,
        ctaUrl,
        cta2Label,
        cta2Url,
        icon,
        bgColor,
        iconColor,
        textColor,
        type,
        audience,
        order,
        active,
        dismissible,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  /// Create a copy of BannerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BannerModelImplCopyWith<_$BannerModelImpl> get copyWith =>
      __$$BannerModelImplCopyWithImpl<_$BannerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BannerModelImplToJson(
      this,
    );
  }
}

abstract class _BannerModel implements BannerModel {
  const factory _BannerModel(
      {final int? id,
      final String? title,
      final String? subtitle,
      @JsonKey(name: 'cta_label') final String? ctaLabel,
      @JsonKey(name: 'cta_url') final String? ctaUrl,
      @JsonKey(name: 'cta2_label') final String? cta2Label,
      @JsonKey(name: 'cta2_url') final String? cta2Url,
      final String? icon,
      @JsonKey(name: 'bg_color') final String? bgColor,
      @JsonKey(name: 'icon_color') final String? iconColor,
      @JsonKey(name: 'text_color') final String? textColor,
      final String? type,
      final String? audience,
      final int? order,
      final bool? active,
      final bool? dismissible,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      final Map<String, dynamic>? metadata}) = _$BannerModelImpl;

  factory _BannerModel.fromJson(Map<String, dynamic> json) =
      _$BannerModelImpl.fromJson;

  @override
  int? get id;
  @override
  String? get title;
  @override
  String? get subtitle;
  @override
  @JsonKey(name: 'cta_label')
  String? get ctaLabel;
  @override
  @JsonKey(name: 'cta_url')
  String? get ctaUrl;
  @override
  @JsonKey(name: 'cta2_label')
  String? get cta2Label;
  @override
  @JsonKey(name: 'cta2_url')
  String? get cta2Url;
  @override
  String? get icon;
  @override
  @JsonKey(name: 'bg_color')
  String? get bgColor;
  @override
  @JsonKey(name: 'icon_color')
  String? get iconColor;
  @override
  @JsonKey(name: 'text_color')
  String? get textColor;
  @override
  String? get type;
  @override
  String? get audience;
  @override
  int? get order;
  @override
  bool? get active;
  @override
  bool? get dismissible;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of BannerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BannerModelImplCopyWith<_$BannerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
