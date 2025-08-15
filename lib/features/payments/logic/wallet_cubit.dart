import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/features/payments/data/models/wallet_response_model.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_dto.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_model.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_response.dart';
import 'package:immoplus_pro/features/payments/data/providers/wallet_provider.dart';
import 'package:immoplus_pro/features/payments/data/repositories/wallet_repository.dart';
import 'package:immoplus_pro/services/navigation_service.dart';

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

  Future onCreateWithdrawalRequest(
      {required WithdrawalRequestDto withdrawalRequestDto}) async {
    try {
      emit(const RequestState.loading());
      WithdrawalRequestModel data =
          await WalletRepository.createWithdrawalRequest(
        withdrawalRequestDto,
      );
      // emit(RequestState.withdrawalRequest(data: data));
      print("POP");
      NavigationService.navigatorKey.currentContext!.pop(data);
      // emit(const RequestState.initial());
    } catch (e) {
      inspect(e);
      emit(const RequestState.initial());
    }
  }

  onSetInitialize() {
    emit(const RequestState.initial());
  }
}
