import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/utils/phone_number_handler.dart';

part 'update_user_dto.freezed.dart';
part 'update_user_dto.g.dart';

@freezed
class UpdateUserDto with _$UpdateUserDto {
  const factory UpdateUserDto({
    String? firstName,
    String? lastName,
    String? avatar,
    @JsonKey(includeIfNull: false) String? email,
    @JsonKey(toJson: _phoneToJson, includeIfNull: false) String? phoneNumber,
  }) = _UpdateUserDto;

  factory UpdateUserDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserDtoFromJson(json);
}

String? _phoneToJson(String? phone) {
  if (phone == null) return null;
  return PhoneNumberHandler.formatPhoneNumber(phone);
}

