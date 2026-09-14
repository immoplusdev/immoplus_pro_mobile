// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_thread_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ConversationThreadState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            ConversationModel conversation,
            List<MessageModel> messages,
            PeerPresence? peerPresence,
            bool peerTyping,
            DateTime? peerLastReadAt,
            String? moderationBannerMessage)
        loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
            ConversationModel conversation,
            List<MessageModel> messages,
            PeerPresence? peerPresence,
            bool peerTyping,
            DateTime? peerLastReadAt,
            String? moderationBannerMessage)?
        loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
            ConversationModel conversation,
            List<MessageModel> messages,
            PeerPresence? peerPresence,
            bool peerTyping,
            DateTime? peerLastReadAt,
            String? moderationBannerMessage)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConversationThreadLoading value) loading,
    required TResult Function(ConversationThreadLoaded value) loaded,
    required TResult Function(ConversationThreadError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConversationThreadLoading value)? loading,
    TResult? Function(ConversationThreadLoaded value)? loaded,
    TResult? Function(ConversationThreadError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConversationThreadLoading value)? loading,
    TResult Function(ConversationThreadLoaded value)? loaded,
    TResult Function(ConversationThreadError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationThreadStateCopyWith<$Res> {
  factory $ConversationThreadStateCopyWith(ConversationThreadState value,
          $Res Function(ConversationThreadState) then) =
      _$ConversationThreadStateCopyWithImpl<$Res, ConversationThreadState>;
}

/// @nodoc
class _$ConversationThreadStateCopyWithImpl<$Res,
        $Val extends ConversationThreadState>
    implements $ConversationThreadStateCopyWith<$Res> {
  _$ConversationThreadStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationThreadState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ConversationThreadLoadingImplCopyWith<$Res> {
  factory _$$ConversationThreadLoadingImplCopyWith(
          _$ConversationThreadLoadingImpl value,
          $Res Function(_$ConversationThreadLoadingImpl) then) =
      __$$ConversationThreadLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ConversationThreadLoadingImplCopyWithImpl<$Res>
    extends _$ConversationThreadStateCopyWithImpl<$Res,
        _$ConversationThreadLoadingImpl>
    implements _$$ConversationThreadLoadingImplCopyWith<$Res> {
  __$$ConversationThreadLoadingImplCopyWithImpl(
      _$ConversationThreadLoadingImpl _value,
      $Res Function(_$ConversationThreadLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationThreadState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ConversationThreadLoadingImpl implements ConversationThreadLoading {
  const _$ConversationThreadLoadingImpl();

  @override
  String toString() {
    return 'ConversationThreadState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationThreadLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            ConversationModel conversation,
            List<MessageModel> messages,
            PeerPresence? peerPresence,
            bool peerTyping,
            DateTime? peerLastReadAt,
            String? moderationBannerMessage)
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
            ConversationModel conversation,
            List<MessageModel> messages,
            PeerPresence? peerPresence,
            bool peerTyping,
            DateTime? peerLastReadAt,
            String? moderationBannerMessage)?
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
            ConversationModel conversation,
            List<MessageModel> messages,
            PeerPresence? peerPresence,
            bool peerTyping,
            DateTime? peerLastReadAt,
            String? moderationBannerMessage)?
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
    required TResult Function(ConversationThreadLoading value) loading,
    required TResult Function(ConversationThreadLoaded value) loaded,
    required TResult Function(ConversationThreadError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConversationThreadLoading value)? loading,
    TResult? Function(ConversationThreadLoaded value)? loaded,
    TResult? Function(ConversationThreadError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConversationThreadLoading value)? loading,
    TResult Function(ConversationThreadLoaded value)? loaded,
    TResult Function(ConversationThreadError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ConversationThreadLoading implements ConversationThreadState {
  const factory ConversationThreadLoading() = _$ConversationThreadLoadingImpl;
}

/// @nodoc
abstract class _$$ConversationThreadLoadedImplCopyWith<$Res> {
  factory _$$ConversationThreadLoadedImplCopyWith(
          _$ConversationThreadLoadedImpl value,
          $Res Function(_$ConversationThreadLoadedImpl) then) =
      __$$ConversationThreadLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {ConversationModel conversation,
      List<MessageModel> messages,
      PeerPresence? peerPresence,
      bool peerTyping,
      DateTime? peerLastReadAt,
      String? moderationBannerMessage});

  $ConversationModelCopyWith<$Res> get conversation;
}

/// @nodoc
class __$$ConversationThreadLoadedImplCopyWithImpl<$Res>
    extends _$ConversationThreadStateCopyWithImpl<$Res,
        _$ConversationThreadLoadedImpl>
    implements _$$ConversationThreadLoadedImplCopyWith<$Res> {
  __$$ConversationThreadLoadedImplCopyWithImpl(
      _$ConversationThreadLoadedImpl _value,
      $Res Function(_$ConversationThreadLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationThreadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversation = null,
    Object? messages = null,
    Object? peerPresence = freezed,
    Object? peerTyping = null,
    Object? peerLastReadAt = freezed,
    Object? moderationBannerMessage = freezed,
  }) {
    return _then(_$ConversationThreadLoadedImpl(
      conversation: null == conversation
          ? _value.conversation
          : conversation // ignore: cast_nullable_to_non_nullable
              as ConversationModel,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageModel>,
      peerPresence: freezed == peerPresence
          ? _value.peerPresence
          : peerPresence // ignore: cast_nullable_to_non_nullable
              as PeerPresence?,
      peerTyping: null == peerTyping
          ? _value.peerTyping
          : peerTyping // ignore: cast_nullable_to_non_nullable
              as bool,
      peerLastReadAt: freezed == peerLastReadAt
          ? _value.peerLastReadAt
          : peerLastReadAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      moderationBannerMessage: freezed == moderationBannerMessage
          ? _value.moderationBannerMessage
          : moderationBannerMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of ConversationThreadState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversationModelCopyWith<$Res> get conversation {
    return $ConversationModelCopyWith<$Res>(_value.conversation, (value) {
      return _then(_value.copyWith(conversation: value));
    });
  }
}

/// @nodoc

class _$ConversationThreadLoadedImpl implements ConversationThreadLoaded {
  const _$ConversationThreadLoadedImpl(
      {required this.conversation,
      required final List<MessageModel> messages,
      this.peerPresence,
      this.peerTyping = false,
      this.peerLastReadAt,
      this.moderationBannerMessage})
      : _messages = messages;

  @override
  final ConversationModel conversation;
  final List<MessageModel> _messages;
  @override
  List<MessageModel> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  final PeerPresence? peerPresence;
  @override
  @JsonKey()
  final bool peerTyping;
  @override
  final DateTime? peerLastReadAt;
  @override
  final String? moderationBannerMessage;

  @override
  String toString() {
    return 'ConversationThreadState.loaded(conversation: $conversation, messages: $messages, peerPresence: $peerPresence, peerTyping: $peerTyping, peerLastReadAt: $peerLastReadAt, moderationBannerMessage: $moderationBannerMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationThreadLoadedImpl &&
            (identical(other.conversation, conversation) ||
                other.conversation == conversation) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.peerPresence, peerPresence) ||
                other.peerPresence == peerPresence) &&
            (identical(other.peerTyping, peerTyping) ||
                other.peerTyping == peerTyping) &&
            (identical(other.peerLastReadAt, peerLastReadAt) ||
                other.peerLastReadAt == peerLastReadAt) &&
            (identical(
                    other.moderationBannerMessage, moderationBannerMessage) ||
                other.moderationBannerMessage == moderationBannerMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      conversation,
      const DeepCollectionEquality().hash(_messages),
      peerPresence,
      peerTyping,
      peerLastReadAt,
      moderationBannerMessage);

  /// Create a copy of ConversationThreadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationThreadLoadedImplCopyWith<_$ConversationThreadLoadedImpl>
      get copyWith => __$$ConversationThreadLoadedImplCopyWithImpl<
          _$ConversationThreadLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            ConversationModel conversation,
            List<MessageModel> messages,
            PeerPresence? peerPresence,
            bool peerTyping,
            DateTime? peerLastReadAt,
            String? moderationBannerMessage)
        loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(conversation, messages, peerPresence, peerTyping,
        peerLastReadAt, moderationBannerMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
            ConversationModel conversation,
            List<MessageModel> messages,
            PeerPresence? peerPresence,
            bool peerTyping,
            DateTime? peerLastReadAt,
            String? moderationBannerMessage)?
        loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(conversation, messages, peerPresence, peerTyping,
        peerLastReadAt, moderationBannerMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
            ConversationModel conversation,
            List<MessageModel> messages,
            PeerPresence? peerPresence,
            bool peerTyping,
            DateTime? peerLastReadAt,
            String? moderationBannerMessage)?
        loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(conversation, messages, peerPresence, peerTyping,
          peerLastReadAt, moderationBannerMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConversationThreadLoading value) loading,
    required TResult Function(ConversationThreadLoaded value) loaded,
    required TResult Function(ConversationThreadError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConversationThreadLoading value)? loading,
    TResult? Function(ConversationThreadLoaded value)? loaded,
    TResult? Function(ConversationThreadError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConversationThreadLoading value)? loading,
    TResult Function(ConversationThreadLoaded value)? loaded,
    TResult Function(ConversationThreadError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ConversationThreadLoaded implements ConversationThreadState {
  const factory ConversationThreadLoaded(
      {required final ConversationModel conversation,
      required final List<MessageModel> messages,
      final PeerPresence? peerPresence,
      final bool peerTyping,
      final DateTime? peerLastReadAt,
      final String? moderationBannerMessage}) = _$ConversationThreadLoadedImpl;

  ConversationModel get conversation;
  List<MessageModel> get messages;
  PeerPresence? get peerPresence;
  bool get peerTyping;
  DateTime? get peerLastReadAt;
  String? get moderationBannerMessage;

  /// Create a copy of ConversationThreadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationThreadLoadedImplCopyWith<_$ConversationThreadLoadedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConversationThreadErrorImplCopyWith<$Res> {
  factory _$$ConversationThreadErrorImplCopyWith(
          _$ConversationThreadErrorImpl value,
          $Res Function(_$ConversationThreadErrorImpl) then) =
      __$$ConversationThreadErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ConversationThreadErrorImplCopyWithImpl<$Res>
    extends _$ConversationThreadStateCopyWithImpl<$Res,
        _$ConversationThreadErrorImpl>
    implements _$$ConversationThreadErrorImplCopyWith<$Res> {
  __$$ConversationThreadErrorImplCopyWithImpl(
      _$ConversationThreadErrorImpl _value,
      $Res Function(_$ConversationThreadErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationThreadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ConversationThreadErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ConversationThreadErrorImpl implements ConversationThreadError {
  const _$ConversationThreadErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ConversationThreadState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationThreadErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ConversationThreadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationThreadErrorImplCopyWith<_$ConversationThreadErrorImpl>
      get copyWith => __$$ConversationThreadErrorImplCopyWithImpl<
          _$ConversationThreadErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            ConversationModel conversation,
            List<MessageModel> messages,
            PeerPresence? peerPresence,
            bool peerTyping,
            DateTime? peerLastReadAt,
            String? moderationBannerMessage)
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
            ConversationModel conversation,
            List<MessageModel> messages,
            PeerPresence? peerPresence,
            bool peerTyping,
            DateTime? peerLastReadAt,
            String? moderationBannerMessage)?
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
            ConversationModel conversation,
            List<MessageModel> messages,
            PeerPresence? peerPresence,
            bool peerTyping,
            DateTime? peerLastReadAt,
            String? moderationBannerMessage)?
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
    required TResult Function(ConversationThreadLoading value) loading,
    required TResult Function(ConversationThreadLoaded value) loaded,
    required TResult Function(ConversationThreadError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConversationThreadLoading value)? loading,
    TResult? Function(ConversationThreadLoaded value)? loaded,
    TResult? Function(ConversationThreadError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConversationThreadLoading value)? loading,
    TResult Function(ConversationThreadLoaded value)? loaded,
    TResult Function(ConversationThreadError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ConversationThreadError implements ConversationThreadState {
  const factory ConversationThreadError(final String message) =
      _$ConversationThreadErrorImpl;

  String get message;

  /// Create a copy of ConversationThreadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationThreadErrorImplCopyWith<_$ConversationThreadErrorImpl>
      get copyWith => throw _privateConstructorUsedError;
}
