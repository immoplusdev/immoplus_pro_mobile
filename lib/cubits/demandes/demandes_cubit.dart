import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus_pro/data/enums/alert_enums.dart';
import 'package:immoplus_pro/data/models/demandes/alert_marketplace_model.dart';
import 'package:immoplus_pro/data/repositories/alerts_repository.dart';
import 'package:immoplus_pro/cubits/demandes/demandes_state.dart';

class DemandesCubit extends Cubit<DemandesState> {
  final PagingController<int, AlertMarketplaceItem> pagingController =
      PagingController(firstPageKey: 1);

  AlertViewFilter _currentFilter = AlertViewFilter.all;
  AlertViewFilter get currentFilter => _currentFilter;

  int _badgeCount = 0;
  int get badgeCount => _badgeCount;

  DemandesCubit() : super(const DemandesInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  void setFilter(AlertViewFilter filter) {
    if (_currentFilter == filter) return;
    _currentFilter = filter;
    pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await AlertsRepository.getMarketplaceAlerts(
        view: _currentFilter,
        page: pageKey,
      );

      final total = response.pagination?.total ?? response.data.length;
      final isLastPage = (response.pagination != null)
          ? pageKey >= response.pagination!.totalPages
          : true;

      if (isLastPage) {
        pagingController.appendLastPage(response.data);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(response.data, nextPageKey);
      }

      emit(DemandesLoaded(
        items: pagingController.itemList ?? response.data,
        totalCount: total,
        badgeCount: _badgeCount,
      ));
    } catch (error) {
      log('Error in DemandesCubit._fetchPage: $error', name: 'DEMANDES_CUBIT');
      pagingController.error = error;
      emit(DemandesError(error.toString()));
    }
  }

  Future<int> fetchBadgeCount() async {
    try {
      final badge = await AlertsRepository.getBadgeCount();
      _badgeCount = badge.newDemandsCount > 0
          ? badge.newDemandsCount
          : badge.totalActiveDemands;

      if (state is DemandesLoaded) {
        emit((state as DemandesLoaded).copyWith(badgeCount: _badgeCount));
      }
      return _badgeCount;
    } catch (e) {
      log('Error fetching badge count: $e', name: 'DEMANDES_CUBIT');
      return _badgeCount;
    }
  }

  Future<void> markAsViewed(String alertId) async {
    try {
      await AlertsRepository.markAsViewed(alertId: alertId);
      // Décrémenter localement si nécessaire
      if (_badgeCount > 0) {
        _badgeCount--;
        if (state is DemandesLoaded) {
          emit((state as DemandesLoaded).copyWith(badgeCount: _badgeCount));
        }
      }
    } catch (e) {
      log('Error markAsViewed in cubit: $e', name: 'DEMANDES_CUBIT');
    }
  }

  void refresh() {
    pagingController.refresh();
    fetchBadgeCount();
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
