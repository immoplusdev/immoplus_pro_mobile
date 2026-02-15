import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/data/repositories/furniture_repository.dart';
import 'package:immoplus_pro/features/furniture_detail/cubit/furniture_state.dart';

/// Cubit pour la gestion d'état de la page détail d'un meuble.

class FurnitureCubit extends Cubit<FurnitureState> {
  FurnitureCubit() : super(const FurnitureState.initial());

  /// Charge les détails d'un meuble par son UUID.
  Future<void> getFurniture(String id) async {
    emit(const FurnitureState.loading());
    try {
      final response = await FurnitureRepository.getFurniture(id);
      if (response.data != null) {
        emit(FurnitureState.loaded(response.data!));
      } else {
        emit(const FurnitureState.initial());
      }
    } catch (e) {
      emit(FurnitureState.error(e.toString()));
    }
  }

  /// Modifie partiellement un meuble. @marc

  Future<void> updateFurniture(
      String id, Map<String, dynamic> fields) async {
    emit(const FurnitureState.loading());
    try {
      final response = await FurnitureRepository.updateFurniture(
          id: id, fields: fields);
      if (response.data != null) {
        emit(FurnitureState.loaded(response.data!));
      } else {
        emit(const FurnitureState.initial());
      }
    } catch (e) {
      emit(FurnitureState.error(e.toString()));
    }
  }

  /// Supprime un meuble (soft delete).
  ///
  /// Émet [FurnitureLoading] → [FurnitureDeleted] ou [FurnitureError].
  Future<void> deleteFurniture(String id) async {
    emit(const FurnitureState.loading());
    try {
      final success =
          await FurnitureRepository.deleteFurniture(id: id);
      if (success) {
        emit(const FurnitureState.deleted('Meuble supprimé avec succès'));
      } else {
        emit(const FurnitureState.error(
            'Échec de la suppression du meuble'));
      }
    } catch (e) {
      emit(FurnitureState.error(e.toString()));
    }
  }
}
