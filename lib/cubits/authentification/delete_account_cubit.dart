import 'package:bloc/bloc.dart';
import 'package:immoplus_pro/cubits/authentification/delete_account_cubit_state.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/utils/status_code_handler.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(const DeleteAccountState.initial());

  Future<void> deleteAccount() async {
    emit(const DeleteAccountState.loading());

    try {
      final userId = SessionManager().currentUser?.userId;

      if (userId == null) {
        emit(const DeleteAccountState.error('Utilisateur non trouvé'));
        ToastUtils.showError(
          title: "Erreur",
          description:
              "Impossible de récupérer les informations de l'utilisateur",
        );
        return;
      }

      final response = await AuthRepository.deleteAccount(userId: userId);

      if (StatusCodeHandler.isSuccess(response.response.statusCode)) {
        emit(const DeleteAccountState.success());

        ToastUtils.showSuccess(
          title: "Compte supprimé",
          description: "Votre compte a été supprimé avec succès",
        );

        // Déconnexion et redirection
        await SessionManager().logout();
      } else {
        emit(const DeleteAccountState.error('Échec de la suppression'));
        ToastUtils.showError(
          title: "Erreur",
          description: "Échec de la suppression du compte",
        );
      }
    } catch (e) {
      emit(DeleteAccountState.error(e.toString()));
      ToastUtils.showError(
        title: "Erreur",
        description: "Une erreur est survenue lors de la suppression du compte",
      );
    }
  }
}
