import 'package:json_annotation/json_annotation.dart';

part 'update_password_body.g.dart';

@JsonSerializable()
class UpdatePasswordBody {
  final String oldPassword;
  final String newPassword;

  UpdatePasswordBody({
    required this.oldPassword,
    required this.newPassword,
  });

  factory UpdatePasswordBody.fromJson(Map<String, Object?> json) =>
      _$UpdatePasswordBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePasswordBodyToJson(this);
}
