import 'package:json_annotation/json_annotation.dart';

part 'verify_email_body.g.dart';

@JsonSerializable()
class VerifyEmailBody {
  final String email;
  final String otp;

  VerifyEmailBody({
    required this.email,
    required this.otp,
  });

  factory VerifyEmailBody.fromJson(Map<String, Object?> json) =>
      _$VerifyEmailBodyFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyEmailBodyToJson(this);
}
