// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_conversation_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateConversationResponse _$CreateConversationResponseFromJson(
    Map<String, dynamic> json) {
  return _CreateConversationResponse.fromJson(json);
}

/// @nodoc
mixin _$CreateConversationResponse {
  ConversationModel get conversation => throw _privateConstructorUsedError;
  MessageModel get message => throw _privateConstructorUsedError;

  /// Serializes this CreateConversationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateConversationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateConversationResponseCopyWith<CreateConversationResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateConversationResponseCopyWith<$Res> {
  factory $CreateConversationResponseCopyWith(CreateConversationResponse value,
          $Res Function(CreateConversationResponse) then) =
      _$CreateConversationResponseCopyWithImpl<$Res,
          CreateConversationResponse>;
  @useResult
  $Res call({ConversationModel conversation, MessageModel message});

  $ConversationModelCopyWith<$Res> get conversation;
  $MessageModelCopyWith<$Res> get message;
}

/// @nodoc
class _$CreateConversationResponseCopyWithImpl<$Res,
        $Val extends CreateConversationResponse>
    implements $CreateConversationResponseCopyWith<$Res> {
  _$CreateConversationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateConversationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversation = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      conversation: null == conversation
          ? _value.conversation
          : conversation // ignore: cast_nullable_to_non_nullable
              as ConversationModel,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as MessageModel,
    ) as $Val);
  }

  /// Create a copy of CreateConversationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversationModelCopyWith<$Res> get conversation {
    return $ConversationModelCopyWith<$Res>(_value.conversation, (value) {
      return _then(_value.copyWith(conversation: value) as $Val);
    });
  }

  /// Create a copy of CreateConversationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageModelCopyWith<$Res> get message {
    return $MessageModelCopyWith<$Res>(_value.message, (value) {
      return _then(_value.copyWith(message: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateConversationResponseImplCopyWith<$Res>
    implements $CreateConversationResponseCopyWith<$Res> {
  factory _$$CreateConversationResponseImplCopyWith(
          _$CreateConversationResponseImpl value,
          $Res Function(_$CreateConversationResponseImpl) then) =
      __$$CreateConversationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ConversationModel conversation, MessageModel message});

  @override
  $ConversationModelCopyWith<$Res> get conversation;
  @override
  $MessageModelCopyWith<$Res> get message;
}

/// @nodoc
class __$$CreateConversationResponseImplCopyWithImpl<$Res>
    extends _$CreateConversationResponseCopyWithImpl<$Res,
        _$CreateConversationResponseImpl>
    implements _$$CreateConversationResponseImplCopyWith<$Res> {
  __$$CreateConversationResponseImplCopyWithImpl(
      _$CreateConversationResponseImpl _value,
      $Res Function(_$CreateConversationResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateConversationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversation = null,
    Object? message = null,
  }) {
    return _then(_$CreateConversationResponseImpl(
      conversation: null == conversation
          ? _value.conversation
          : conversation // ignore: cast_nullable_to_non_nullable
              as ConversationModel,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as MessageModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateConversationResponseImpl implements _CreateConversationResponse {
  const _$CreateConversationResponseImpl(
      {required this.conversation, required this.message});

  factory _$CreateConversationResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateConversationResponseImplFromJson(json);

  @override
  final ConversationModel conversation;
  @override
  final MessageModel message;

  @override
  String toString() {
    return 'CreateConversationResponse(conversation: $conversation, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateConversationResponseImpl &&
            (identical(other.conversation, conversation) ||
                other.conversation == conversation) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, conversation, message);

  /// Create a copy of CreateConversationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateConversationResponseImplCopyWith<_$CreateConversationResponseImpl>
      get copyWith => __$$CreateConversationResponseImplCopyWithImpl<
          _$CreateConversationResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateConversationResponseImplToJson(
      this,
    );
  }
}

abstract class _CreateConversationResponse
    implements CreateConversationResponse {
  const factory _CreateConversationResponse(
      {required final ConversationModel conversation,
      required final MessageModel message}) = _$CreateConversationResponseImpl;

  factory _CreateConversationResponse.fromJson(Map<String, dynamic> json) =
      _$CreateConversationResponseImpl.fromJson;

  @override
  ConversationModel get conversation;
  @override
  MessageModel get message;

  /// Create a copy of CreateConversationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateConversationResponseImplCopyWith<_$CreateConversationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
