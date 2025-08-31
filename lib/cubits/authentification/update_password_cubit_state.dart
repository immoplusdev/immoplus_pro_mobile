import 'package:freezed_annotation/freezed_annotation.dart';
part 'update_password_cubit_state.freezed.dart';

@freezed
class UpdatePasswordCubitState with _$UpdatePasswordCubitState {
  const factory UpdatePasswordCubitState.initial() = _Initial;
  const factory UpdatePasswordCubitState.submitting() = _Submitting;
  const factory UpdatePasswordCubitState.success({required String message}) =
      _Success;
  const factory UpdatePasswordCubitState.error({required String errorMessage}) =
      _Error;
}
