import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/features/payments/data/models/wallet_response_model.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_dto.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_model.dart';
import 'package:immoplus_pro/features/payments/data/repositories/wallet_repository.dart';

class WalletCubit extends Cubit<RequestState> {
  WalletCubit() : super(const RequestState.initial());

  // onGetBookingPaymentHistory() async {
  //   try {
  //     emit(const RequestState.loading());
  //     WithdrawBookingHistoryDto data =
  //         await LogmentRepository.getWithdrawReservations(
  //             userId: SessionManager().currentUser!.userId!);
  //     emit(RequestState.bookingWithdrowhistory(data: data));
  //   } catch (e) {
  //     emit(const RequestState.initial());
  //   }
  // }

  onGetWallet() async {
    try {
      emit(const RequestState.loading());
      WalletResponseModel data = await WalletRepository.getWallet();
      inspect(data);
      emit(RequestState.wallet(data: data.data!));
    } catch (e) {
      emit(const RequestState.initial());
    }
  }

  Future<WithdrawalRequestModel?> onCreateWithdrawalRequest(
      {required WithdrawalRequestDto withdrawalRequestDto}) async {
    try {
      emit(const RequestState.loading());
      WithdrawalRequestModel data =
          await WalletRepository.createWithdrawalRequest(
        withdrawalRequestDto,
      );
      emit(const RequestState.initial());
      return data;
    } catch (e) {
      inspect(e);
      emit(const RequestState.initial());
      return null;
    }
  }

  /// Demande de retrait liée à une réservation validée par scan QR — pas de
  /// montant à fournir, il est calculé côté backend depuis la réservation.
  Future<bool> onCreateWithdrawalRequestFromQr({
    required String reservationId,
    required String phoneNumber,
    required String operator,
  }) async {
    try {
      emit(const RequestState.loading());
      await WalletRepository.createWithdrawalRequestFromQr(
        reservationId: reservationId,
        phoneNumber: phoneNumber,
        operator: operator,
      );
      emit(const RequestState.initial());
      return true;
    } catch (e) {
      inspect(e);
      emit(const RequestState.initial());
      return false;
    }
  }

  onSetInitialize() {
    emit(const RequestState.initial());
  }
}
