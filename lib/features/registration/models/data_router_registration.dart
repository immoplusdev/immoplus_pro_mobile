class DataRouterRegistration {
  String email;
  String token;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? provider;
  DataRouterRegistration(
      {required this.email,
      required this.token,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.provider});
}
