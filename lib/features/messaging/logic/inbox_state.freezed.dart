// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbox_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InboxState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            List<ConversationModel> conversations,
            ConversationType? activeType,
            List<ConversationTypeCount> counts,
            bool isRefreshing,
            bool isSwitchingTab)
        loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
            List<ConversationModel> conversations,
            ConversationType? activeType,
            List<ConversationTypeCount> counts,
            bool isRefreshing,
            bool isSwitchingTab)?
        loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
            List<ConversationModel> conversations,
            ConversationType? activeType,
            List<ConversationTypeCount> counts,
            bool isRefreshing,
            bool isSwitchingTab)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InboxLoading value) loading,
    required TResult Function(InboxLoaded value) loaded,
    required TResult Function(InboxError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InboxLoading value)? loading,
    TResult? Function(InboxLoaded value)? loaded,
    TResult? Function(InboxError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InboxLoading value)? loading,
    TResult Function(InboxLoaded value)? loaded,
    TResult Function(InboxError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InboxStateCopyWith<$Res> {
  factory $InboxStateCopyWith(
          InboxState value, $Res Function(InboxState) then) =
      _$InboxStateCopyWithImpl<$Res, InboxState>;
}

/// @nodoc
class _$InboxStateCopyWithImpl<$Res, $Val extends InboxState>
    implements $InboxStateCopyWith<$Res> {
  _$InboxStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InboxState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InboxLoadingImplCopyWith<$Res> {
  factory _$$InboxLoadingImplCopyWith(
          _$InboxLoadingImpl value, $Res Function(_$InboxLoadingImpl) then) =
      __$$InboxLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InboxLoadingImplCopyWithImpl<$Res>
    extends _$InboxStateCopyWithImpl<$Res, _$InboxLoadingImpl>
    implements _$$InboxLoadingImplCopyWith<$Res> {
  __$$InboxLoadingImplCopyWithImpl(
      _$InboxLoadingImpl _value, $Res Function(_$InboxLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of InboxState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InboxLoadingImpl implements InboxLoading {
  const _$InboxLoadingImpl();

  @override
  String toString() {
    return 'InboxState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InboxLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            List<ConversationModel> conversations,
            ConversationType? activeType,
            List<ConversationTypeCount> counts,
            bool isRefreshing,
            bool isSwitchingTab)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
            List<ConversationModel> conversations,
            ConversationType? activeType,
            List<ConversationTypeCount> counts,
            bool isRefreshing,
            bool isSwitchingTab)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
            List<ConversationModel> conversations,
            ConversationType? activeType,
            List<ConversationTypeCount> counts,
            bool isRefreshing,
            bool isSwitchingTab)?
        loaded,
    TResult Function(String message)? error,
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
    required TResult Function(InboxLoading value) loading,
    required TResult Function(InboxLoaded value) loaded,
    required TResult Function(InboxError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InboxLoading value)? loading,
    TResult? Function(InboxLoaded value)? loaded,
    TResult? Function(InboxError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InboxLoading value)? loading,
    TResult Function(InboxLoaded value)? loaded,
    TResult Function(InboxError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class InboxLoading implements InboxState {
  const factory InboxLoading() = _$InboxLoadingImpl;
}

/// @nodoc
abstract class _$$InboxLoadedImplCopyWith<$Res> {
  factory _$$InboxLoadedImplCopyWith(
          _$InboxLoadedImpl value, $Res Function(_$InboxLoadedImpl) then) =
      __$$InboxLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<ConversationModel> conversations,
      ConversationType? activeType,
      List<ConversationTypeCount> counts,
      bool isRefreshing,
      bool isSwitchingTab});
}

/// @nodoc
class __$$InboxLoadedImplCopyWithImpl<$Res>
    extends _$InboxStateCopyWithImpl<$Res, _$InboxLoadedImpl>
    implements _$$InboxLoadedImplCopyWith<$Res> {
  __$$InboxLoadedImplCopyWithImpl(
      _$InboxLoadedImpl _value, $Res Function(_$InboxLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of InboxState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversations = null,
    Object? activeType = freezed,
    Object? counts = null,
    Object? isRefreshing = null,
    Object? isSwitchingTab = null,
  }) {
    return _then(_$InboxLoadedImpl(
      conversations: null == conversations
          ? _value._conversations
          : conversations // ignore: cast_nullable_to_non_nullable
              as List<ConversationModel>,
      activeType: freezed == activeType
          ? _value.activeType
          : activeType // ignore: cast_nullable_to_non_nullable
              as ConversationType?,
      counts: null == counts
          ? _value._counts
          : counts // ignore: cast_nullable_to_non_nullable
              as List<ConversationTypeCount>,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      isSwitchingTab: null == isSwitchingTab
          ? _value.isSwitchingTab
          : isSwitchingTab // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$InboxLoadedImpl implements InboxLoaded {
  const _$InboxLoadedImpl(
      {required final List<ConversationModel> conversations,
      this.activeType,
      final List<ConversationTypeCount> counts = const [],
      this.isRefreshing = false,
      this.isSwitchingTab = false})
      : _conversations = conversations,
        _counts = counts;

  final List<ConversationModel> _conversations;
  @override
  List<ConversationModel> get conversations {
    if (_conversations is EqualUnmodifiableListView) return _conversations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conversations);
  }

  /// `null` = onglet "Toutes".
  @override
  final ConversationType? activeType;
  final List<ConversationTypeCount> _counts;
  @override
  @JsonKey()
  List<ConversationTypeCount> get counts {
    if (_counts is EqualUnmodifiableListView) return _counts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_counts);
  }

  @override
  @JsonKey()
  final bool isRefreshing;

  /// Distinct de [isRefreshing] : bascule d'onglet en cours — seule la
  /// liste se recharge en skeleton, pas les onglets déjà affichés, qui
  /// restent visibles avec leurs compteurs.
  @override
  @JsonKey()
  final bool isSwitchingTab;

  @override
  String toString() {
    return 'InboxState.loaded(conversations: $conversations, activeType: $activeType, counts: $counts, isRefreshing: $isRefreshing, isSwitchingTab: $isSwitchingTab)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InboxLoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._conversations, _conversations) &&
            (identical(other.activeType, activeType) ||
                other.activeType == activeType) &&
            const DeepCollectionEquality().equals(other._counts, _counts) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.isSwitchingTab, isSwitchingTab) ||
                other.isSwitchingTab == isSwitchingTab));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_conversations),
      activeType,
      const DeepCollectionEquality().hash(_counts),
      isRefreshing,
      isSwitchingTab);

  /// Create a copy of InboxState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InboxLoadedImplCopyWith<_$InboxLoadedImpl> get copyWith =>
      __$$InboxLoadedImplCopyWithImpl<_$InboxLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            List<ConversationModel> conversations,
            ConversationType? activeType,
            List<ConversationTypeCount> counts,
            bool isRefreshing,
            bool isSwitchingTab)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(
        conversations, activeType, counts, isRefreshing, isSwitchingTab);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
            List<ConversationModel> conversations,
            ConversationType? activeType,
            List<ConversationTypeCount> counts,
            bool isRefreshing,
            bool isSwitchingTab)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(
        conversations, activeType, counts, isRefreshing, isSwitchingTab);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
            List<ConversationModel> conversations,
            ConversationType? activeType,
            List<ConversationTypeCount> counts,
            bool isRefreshing,
            bool isSwitchingTab)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
          conversations, activeType, counts, isRefreshing, isSwitchingTab);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InboxLoading value) loading,
    required TResult Function(InboxLoaded value) loaded,
    required TResult Function(InboxError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InboxLoading value)? loading,
    TResult? Function(InboxLoaded value)? loaded,
    TResult? Function(InboxError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InboxLoading value)? loading,
    TResult Function(InboxLoaded value)? loaded,
    TResult Function(InboxError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class InboxLoaded implements InboxState {
  const factory InboxLoaded(
      {required final List<ConversationModel> conversations,
      final ConversationType? activeType,
      final List<ConversationTypeCount> counts,
      final bool isRefreshing,
      final bool isSwitchingTab}) = _$InboxLoadedImpl;

  List<ConversationModel> get conversations;

  /// `null` = onglet "Toutes".
  ConversationType? get activeType;
  List<ConversationTypeCount> get counts;
  bool get isRefreshing;

  /// Distinct de [isRefreshing] : bascule d'onglet en cours — seule la
  /// liste se recharge en skeleton, pas les onglets déjà affichés, qui
  /// restent visibles avec leurs compteurs.
  bool get isSwitchingTab;

  /// Create a copy of InboxState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InboxLoadedImplCopyWith<_$InboxLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InboxErrorImplCopyWith<$Res> {
  factory _$$InboxErrorImplCopyWith(
          _$InboxErrorImpl value, $Res Function(_$InboxErrorImpl) then) =
      __$$InboxErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$InboxErrorImplCopyWithImpl<$Res>
    extends _$InboxStateCopyWithImpl<$Res, _$InboxErrorImpl>
    implements _$$InboxErrorImplCopyWith<$Res> {
  __$$InboxErrorImplCopyWithImpl(
      _$InboxErrorImpl _value, $Res Function(_$InboxErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of InboxState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$InboxErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InboxErrorImpl implements InboxError {
  const _$InboxErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'InboxState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InboxErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of InboxState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InboxErrorImplCopyWith<_$InboxErrorImpl> get copyWith =>
      __$$InboxErrorImplCopyWithImpl<_$InboxErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            List<ConversationModel> conversations,
            ConversationType? activeType,
            List<ConversationTypeCount> counts,
            bool isRefreshing,
            bool isSwitchingTab)
        loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
            List<ConversationModel> conversations,
            ConversationType? activeType,
            List<ConversationTypeCount> counts,
            bool isRefreshing,
            bool isSwitchingTab)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
            List<ConversationModel> conversations,
            ConversationType? activeType,
            List<ConversationTypeCount> counts,
            bool isRefreshing,
            bool isSwitchingTab)?
        loaded,
    TResult Function(String message)? error,
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
    required TResult Function(InboxLoading value) loading,
    required TResult Function(InboxLoaded value) loaded,
    required TResult Function(InboxError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(InboxLoading value)? loading,
    TResult? Function(InboxLoaded value)? loaded,
    TResult? Function(InboxError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InboxLoading value)? loading,
    TResult Function(InboxLoaded value)? loaded,
    TResult Function(InboxError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class InboxError implements InboxState {
  const factory InboxError(final String message) = _$InboxErrorImpl;

  String get message;

  /// Create a copy of InboxState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InboxErrorImplCopyWith<_$InboxErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
