import 'package:immoplus_pro/data/enums/contact_change_type.dart';

abstract class ContactChangeState {}

class ContactChangeInitial extends ContactChangeState {}

// Étape 1
class ContactChangeRequestLoading extends ContactChangeState {}

class ContactChangeRequestSuccess extends ContactChangeState {
  final ContactChangeType type;
  ContactChangeRequestSuccess(this.type);
}

class ContactChangeRequestError extends ContactChangeState {
  final String message;
  ContactChangeRequestError(this.message);
}

// Étape 2
class ContactChangeConfirmLoading extends ContactChangeState {}

class ContactChangeConfirmSuccess extends ContactChangeState {
  final String message;
  ContactChangeConfirmSuccess(this.message);
}

class ContactChangeConfirmError extends ContactChangeState {
  final String message;
  ContactChangeConfirmError(this.message);
}
