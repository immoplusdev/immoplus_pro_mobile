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
      emit(OwnerStatsError(e.toString()));
    }
  }

  Future<void> refresh() async {
    await loadStats(period: _currentPeriod);
  }
}
