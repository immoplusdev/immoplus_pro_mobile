import 'package:json_annotation/json_annotation.dart';

part 'verify_email_otp.g.dart';

@JsonSerializable()
class VerifyEmailOtp {
  final String? email;
  final String? phoneNumber;
  final String otp;

  VerifyEmailOtp({
    this.email,
    this.phoneNumber,
    required this.otp,
  });

  factory VerifyEmailOtp.fromJson(Map<String, dynamic> json) =>
      _$VerifyEmailOtpFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyEmailOtpToJson(this);
}
