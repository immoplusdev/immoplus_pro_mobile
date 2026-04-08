import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:immoplus_pro/features/contract/logic/contract_state.dart';

class ContractCubit extends Cubit<ContractState> {
  ContractCubit() : super(const ContractState.initial());

  Future<void> signContract(Uint8List signatureBytes) async {
    emit(const ContractState.loading());

    try {
      // TODO: Appel API pour sauvegarder la signature
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const ContractState.signed());
    } catch (e) {
      emit(ContractState.error(e.toString()));
    }
  }
}
