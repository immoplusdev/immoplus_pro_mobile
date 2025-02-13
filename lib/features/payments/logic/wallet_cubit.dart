import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/data/models/auth/withdraw_booking_history_dto.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class WalletCubit extends Cubit<RequestState> {
  WalletCubit() : super(const RequestState.initial());

  onGetBookingPaymentHistory() async {
    try {
      emit(const RequestState.loading());
      WithdrawBookingHistoryDto data =
          await LogmentRepository.getWithdrawReservations(
              userId: SessionManager().currentUser!.userId!);
      emit(RequestState.bookingWithdrowhistory(data: data));
    } catch (e) {
      emit(const RequestState.initial());
    }
  }

  onSetInitialize() {
    emit(const RequestState.initial());
  }
}
