// ignore_for_file: constant_identifier_names

enum Roles {
  pro_particulier,
  pro_entreprise,
  customer,
}

String getRoleDescription(String role) {
  switch (role) {
    case "pro_particulier":
      return "Professionnel Particulier";
    case "pro_entreprise":
      return "Professionnel Entreprise";
    case "customer":
      return "Client";
    default:
      return "Rôle inconnu";
  }
}
