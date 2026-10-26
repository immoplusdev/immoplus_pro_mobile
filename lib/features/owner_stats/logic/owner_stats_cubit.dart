import 'package:immoplus_pro/core/error/error_feedback.dart';
import 'package:immoplus_pro/core/error/error_messages.dart';
import 'package:immoplus_pro/core/error/error_context.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/features/owner_stats/data/owner_stats_repository.dart';
import 'package:immoplus_pro/features/owner_stats/logic/owner_stats_state.dart';

class OwnerStatsCubit extends Cubit<OwnerStatsState> {
  OwnerStatsCubit() : super(OwnerStatsInitial());

  String _currentPeriod = 'month';

  String get currentPeriod => _currentPeriod;

  Future<void> loadStats({String period = 'month'}) async {
    _currentPeriod = period;
    emit(OwnerStatsLoading());
    try {
      final stats = await OwnerStatsRepository.getStats(period: period);
      emit(OwnerStatsLoaded(stats));
    } catch (e) {
      ErrorFeedback.show(e, context: ErrorContext.feedLoad);
      emit(OwnerStatsError(ErrorMessages.messageOf(e, ErrorContext.feedLoad)));
    }
  }

  Future<void> refresh() async {
    await loadStats(period: _currentPeriod);
  }
}
