enum ApiErrorCode {
  // Erreurs d'authentification
  unauthorized('UNAUTHORIZED'),
  authenticationFailed('AUTHENTICATION_FAILED'),
  invalidPassword('INVALID_PASSWORD'),
  wrongPassword('WRONG_PASSWORD'),

  // Erreurs de token JWT
  jwtTokenExpired('JWT_TOKEN_EXPIRED'),
  jwtTokenInvalid('JWT_TOKEN_INVALID'),
  jwtTokenNotActive('JWT_TOKEN_NOT_ACTIVE'),
  jwtTokenMissing('JWT_TOKEN_MISSING'),
  invalidRefreshToken('INVALID_REFRESH_TOKEN'),

  // Erreurs de permissions
  insufficientPermissions('INSUFFICIENT_PERMISSIONS'),

  // Erreurs de validation
  invalidOtp('INVALID_OTP'),

  socialAccountNotFound('SOCIAL_ACCOUNT_NOT_FOUND'),

  // Utilisateur introuvable (ex: OTP envoyé à un numéro non enregistré)
  userNotFound('USER_NOT_FOUND'),

  // Numéro de téléphone déjà utilisé par un autre compte (inscription)
  phoneNumberAlreadyTaken('PHONE_NUMBER_ALREADY_TAKEN'),

  // Type de compte non autorisé sur cette application (ex: compte client
  // ImmoPlus utilisé sur ImmoPlus Pro)
  forbidden('FORBIDDEN'),

  // Erreur inconnue
  unknown('UNKNOWN');

  const ApiErrorCode(this.value);

  final String value;

  /// Crée un enum à partir d'un string
  static ApiErrorCode fromString(String? code) {
    return ApiErrorCode.values.firstWhere(
      (e) => e.value == code,
      orElse: () => ApiErrorCode.unknown,
    );
  }

  /// Vérifie si l'erreur est liée à l'authentification
  bool get isAuthRelated {
    switch (this) {
      case ApiErrorCode.unauthorized:
      case ApiErrorCode.authenticationFailed:
      case ApiErrorCode.invalidPassword:
      case ApiErrorCode.wrongPassword:
      case ApiErrorCode.jwtTokenExpired:
      case ApiErrorCode.jwtTokenInvalid:
      case ApiErrorCode.jwtTokenNotActive:
      case ApiErrorCode.jwtTokenMissing:
      case ApiErrorCode.invalidRefreshToken:
        return true;
      default:
        return false;
    }
  }

  /// Vérifie si l'erreur nécessite une déconnexion complète
  bool get requiresLogout {
    switch (this) {
      case ApiErrorCode.invalidRefreshToken:
        return true;
      default:
        return false;
    }
  }

  /// Vérifie si l'erreur est affichée via un dialog dédié (ApiErrorDialog)
  /// [ApiErrorCode.forbidden] est volontairement exclu : ce code est
  /// renvoyé par le backend pour n'importe quel refus d'autorisation métier

  bool get hasDedicatedDialog {
    switch (this) {
      case ApiErrorCode.userNotFound:
      case ApiErrorCode.phoneNumberAlreadyTaken:
        return true;
      default:
        return false;
    }
  }
}
