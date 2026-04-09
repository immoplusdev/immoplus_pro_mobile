import 'package:freezed_annotation/freezed_annotation.dart';

part 'contract_state.freezed.dart';

@freezed
class ContractState with _$ContractState {
  const factory ContractState.initial() = _Initial;
  const factory ContractState.loading() = _Loading;
  const factory ContractState.signed() = _Signed;
  const factory ContractState.error(String message) = _Error;
}
