import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus_pro/data/models/auth/account_creation_response.dart';
import 'package:immoplus_pro/data/models/auth/custom_registration_body.dart';
import 'package:immoplus_pro/data/models/auth/enterprise_registration_body.dart';
import 'package:immoplus_pro/data/models/auth/login_body_model.dart';
import 'package:immoplus_pro/data/models/auth/login_otp_body.dart';
import 'package:immoplus_pro/data/models/auth/particulier_registration_body.dart';
import 'package:immoplus_pro/data/models/auth/reset_password_body.dart';
import 'package:immoplus_pro/data/models/auth/send_email_otp_body.dart';
import 'package:immoplus_pro/data/models/auth/send_opt_model.dart';
import 'package:immoplus_pro/data/models/auth/update_user_dto.dart';
import 'package:immoplus_pro/data/models/auth/update_user_response_model.dart';
import 'package:immoplus_pro/data/models/auth/verify_email_body.dart';
import 'package:immoplus_pro/data/models/files/file_data_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class AuthProvider {
  factory AuthProvider(Dio dio, {String baseUrl}) = _AuthProvider;

  @POST("/files/public")
  @MultiPart()
  Future<FileDataModel> uploadImage(
    @Part(name: "file") File file,
  );
  @POST('/auth/login')
  Future<AccountCreationResponse> login(@Body() LoginBodyModel loginBodyModel);

  @POST('/auth/register-customer')
  Future<AccountCreationResponse> registrationCustomer(
      @Body() CustomerRegistrationBody customRegistrationBody);

  @POST('/auth/register-pro-entreprise')
  Future<AccountCreationResponse> registrationEnterprise(
      @Body() EnterpriseRegistrationBody enterpriseRegistrationBody);

  @POST('/auth/register-pro-particulier')
  Future<AccountCreationResponse> registrationParticulier(
      @Body() ParticulierRegistrationBody particulierRegistrationBody);

  @POST('/auth/send-sms-otp')
  Future<HttpResponse> sendOtp(@Body() SendOptModel sendOptModel);

  @POST('/auth/login-with-phone-number-otp')
  Future<AccountCreationResponse> loginOtp(@Body() LoginOtpBody loginOtpBody);

  @PATCH('/users/{id}')
  Future<UpdateUserResponseModel> updateUser(
      @Path() String id, @Body() UpdateUserDto updateUserDto);

  @POST('/auth/send-email-otp')
  Future<HttpResponse> sendEmailOtp(@Body() SendEmailOtpBody sendEmailOtpBody);

  @POST('/auth/verify-email')
  Future<HttpResponse> verifyEmail(@Body() VerifyEmailBody verifyEmailBody);

  @POST('/auth/reset-password')
  Future<HttpResponse> resetPassword(
      @Body() ResetPasswordBody resetPasswordBody);
}
