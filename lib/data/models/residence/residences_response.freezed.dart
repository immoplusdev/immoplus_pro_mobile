// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'residences_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResidencesResponse _$ResidencesResponseFromJson(Map<String, dynamic> json) {
  return _ResidencesResponse.fromJson(json);
}

/// @nodoc
mixin _$ResidencesResponse {
  List<ResidenceModel>? get data => throw _privateConstructorUsedError;
  int? get currentPage => throw _privateConstructorUsedError;
  int? get totalPages => throw _privateConstructorUsedError;
  int? get pageSize => throw _privateConstructorUsedError;
  bool? get hasNext => throw _privateConstructorUsedError;
  bool? get hasPrevious => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResidencesResponseCopyWith<ResidencesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResidencesResponseCopyWith<$Res> {
  factory $ResidencesResponseCopyWith(
          ResidencesResponse value, $Res Function(ResidencesResponse) then) =
      _$ResidencesResponseCopyWithImpl<$Res, ResidencesResponse>;
  @useResult
  $Res call(
      {List<ResidenceModel>? data,
      int? currentPage,
      int? totalPages,
      int? pageSize,
      bool? hasNext,
      bool? hasPrevious});
}

/// @nodoc
class _$ResidencesResponseCopyWithImpl<$Res, $Val extends ResidencesResponse>
    implements $ResidencesResponseCopyWith<$Res> {
  _$ResidencesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? currentPage = freezed,
    Object? totalPages = freezed,
    Object? pageSize = freezed,
    Object? hasNext = freezed,
    Object? hasPrevious = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ResidenceModel>?,
      currentPage: freezed == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: freezed == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int?,
      hasNext: freezed == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasPrevious: freezed == hasPrevious
          ? _value.hasPrevious
          : hasPrevious // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResidencesResponseImplCopyWith<$Res>
    implements $ResidencesResponseCopyWith<$Res> {
  factory _$$ResidencesResponseImplCopyWith(_$ResidencesResponseImpl value,
          $Res Function(_$ResidencesResponseImpl) then) =
      __$$ResidencesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ResidenceModel>? data,
      int? currentPage,
      int? totalPages,
      int? pageSize,
      bool? hasNext,
      bool? hasPrevious});
}

/// @nodoc
class __$$ResidencesResponseImplCopyWithImpl<$Res>
    extends _$ResidencesResponseCopyWithImpl<$Res, _$ResidencesResponseImpl>
    implements _$$ResidencesResponseImplCopyWith<$Res> {
  __$$ResidencesResponseImplCopyWithImpl(_$ResidencesResponseImpl _value,
      $Res Function(_$ResidencesResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? currentPage = freezed,
    Object? totalPages = freezed,
    Object? pageSize = freezed,
    Object? hasNext = freezed,
    Object? hasPrevious = freezed,
  }) {
    return _then(_$ResidencesResponseImpl(
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ResidenceModel>?,
      currentPage: freezed == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      totalPages: freezed == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int?,
      pageSize: freezed == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int?,
      hasNext: freezed == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasPrevious: freezed == hasPrevious
          ? _value.hasPrevious
          : hasPrevious // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResidencesResponseImpl implements _ResidencesResponse {
  _$ResidencesResponseImpl(
      {final List<ResidenceModel>? data = const [],
      this.currentPage = 0,
      this.totalPages = 0,
      this.pageSize = 0,
      this.hasNext = false,
      this.hasPrevious = false})
      : _data = data;

  factory _$ResidencesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResidencesResponseImplFromJson(json);

  final List<ResidenceModel>? _data;
  @override
  @JsonKey()
  List<ResidenceModel>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final int? currentPage;
  @override
  @JsonKey()
  final int? totalPages;
  @override
  @JsonKey()
  final int? pageSize;
  @override
  @JsonKey()
  final bool? hasNext;
  @override
  @JsonKey()
  final bool? hasPrevious;

  @override
  String toString() {
    return 'ResidencesResponse(data: $data, currentPage: $currentPage, totalPages: $totalPages, pageSize: $pageSize, hasNext: $hasNext, hasPrevious: $hasPrevious)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResidencesResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            (identical(other.hasPrevious, hasPrevious) ||
                other.hasPrevious == hasPrevious));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_data),
      currentPage,
      totalPages,
      pageSize,
      hasNext,
      hasPrevious);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResidencesResponseImplCopyWith<_$ResidencesResponseImpl> get copyWith =>
      __$$ResidencesResponseImplCopyWithImpl<_$ResidencesResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResidencesResponseImplToJson(
      this,
    );
  }
}

abstract class _ResidencesResponse implements ResidencesResponse {
  factory _ResidencesResponse(
      {final List<ResidenceModel>? data,
      final int? currentPage,
      final int? totalPages,
      final int? pageSize,
      final bool? hasNext,
      final bool? hasPrevious}) = _$ResidencesResponseImpl;

  factory _ResidencesResponse.fromJson(Map<String, dynamic> json) =
      _$ResidencesResponseImpl.fromJson;

  @override
  List<ResidenceModel>? get data;
  @override
  int? get currentPage;
  @override
  int? get totalPages;
  @override
  int? get pageSize;
  @override
  bool? get hasNext;
  @override
  bool? get hasPrevious;
  @override
  @JsonKey(ignore: true)
  _$$ResidencesResponseImplCopyWith<_$ResidencesResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
