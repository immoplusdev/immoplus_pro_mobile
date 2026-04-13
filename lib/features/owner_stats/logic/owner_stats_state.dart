import 'package:immoplus_pro/features/owner_stats/data/models/owner_stats_dto.dart';

abstract class OwnerStatsState {}

class OwnerStatsInitial extends OwnerStatsState {}

class OwnerStatsLoading extends OwnerStatsState {}

class OwnerStatsLoaded extends OwnerStatsState {
  final OwnerStatsDto stats;
  OwnerStatsLoaded(this.stats);
}

class OwnerStatsError extends OwnerStatsState {
  final String message;
  OwnerStatsError(this.message);
}
