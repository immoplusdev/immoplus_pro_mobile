import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_model.dart';

part 'furniture_state.freezed.dart';

/// États du [FurnitureCubit] pour la page détail d'un meuble.

@freezed
class FurnitureState with _$FurnitureState {
  const factory FurnitureState.initial() = FurnitureInitial;
  const factory FurnitureState.loading() = FurnitureLoading;
  const factory FurnitureState.loaded(FurnitureModel furniture) =
      FurnitureLoaded;
  const factory FurnitureState.deleted(String message) = FurnitureDeleted;
  const factory FurnitureState.error(String message) = FurnitureError;
}
