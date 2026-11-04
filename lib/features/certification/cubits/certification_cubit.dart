import 'package:immoplus_pro/core/error/error_feedback.dart';
import 'package:immoplus_pro/core/error/error_messages.dart';
import 'package:immoplus_pro/core/error/error_context.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/features/certification/repositories/certification_repository.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CertificationCubit extends Cubit<RequestState> {
  CertificationCubit() : super(const RequestState.initial());

  Future<void> loadCertification() async {
    try {
      emit(const RequestState.loading());
      final certification = await CertificationRepository.getMyCertification();
      emit(RequestState.certification(data: certification));
    } catch (e) {
      ErrorFeedback.show(e, context: ErrorContext.certification);
      emit(RequestState.error(error: ErrorMessages.messageOf(e, ErrorContext.certification)));
    }
  }
}
