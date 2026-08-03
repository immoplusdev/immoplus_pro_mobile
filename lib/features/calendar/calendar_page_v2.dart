import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:immoplus_pro/core/showcase/showcase_coordinator.dart';

import 'calendar_date_utils.dart';
import 'calendar_theme.dart';
import 'widgets/blocked_date_section.dart';
import 'widgets/block_sheet.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/calendar_top_bar.dart';
import 'widgets/calendar_ui_widgets.dart';
import 'widgets/residence_strip.dart';
import 'widgets/unblock_sheet.dart';

class CalendarPageV2 extends StatefulWidget {
  const CalendarPageV2({super.key});

  static const name      = 'CALENDAR_PAGE_V2';
  static const routePath = '/calendar_v2';

  @override
  State<CalendarPageV2> createState() => _CalendarPageV2State();
}

class _CalendarPageV2State extends State<CalendarPageV2> {
  // ── State ─────────────────────────────────────────────────────────────────

  late DateTime _visibleMonth = calFirstDayOfMonth(DateTime.now());
  List<ResidenceModel> _residences    = [];
  ResidenceModel?       _activeResidence;
  DateTime?             _selectionStart;
  DateTime?             _selectionEnd;
  bool _isLoading   = true;
  bool _isSaving    = false;
  bool _isPanActive = false;
  String? _errorMessage;

  final GlobalKey _tutorialKey1 = GlobalKey();
  final GlobalKey _tutorialKey2 = GlobalKey();
  bool _tutorialChecked = false;

  // ── Derived ───────────────────────────────────────────────────────────────

  DateTime get _today => calDateOnly(DateTime.now());

  List<DateTime> get _visibleDays => calVisibleDays(_visibleMonth);

  List<DateTime> get _selectedRange => calSelectedRange(_selectionStart, _selectionEnd);

  List<String> get _selectedDateKeys =>
      _selectedRange.map(calFormatApiDate).toSet().toList()..sort();

  DateTime get _firstValidDay {
    try {
      return _visibleDays.firstWhere(
        (d) => !calIsBeforeToday(d) && _blockedResidencesFor(d).isEmpty,
      );
    } catch (_) {
      return _today;
    }
  }

  List<ResidenceModel> _blockedResidencesFor(DateTime day) {
    final key    = calFormatApiDate(day);
    final source = _activeResidence == null ? _residences : [_activeResidence!];
    return source
        .where((r) => _blockedKeysFor(r).contains(key))
        .toList();
  }

  Set<String> _blockedKeysFor(ResidenceModel r) {
    return r.datesReservation
        .map((item) => calParseApiDate(item.date))
        .whereType<DateTime>()
        .map(calFormatApiDate)
        .toSet();
  }

  List<MapEntry<String, List<ResidenceModel>>> get _monthBlockedEntries {
    final grouped = <String, List<ResidenceModel>>{};
    final source  = _activeResidence == null ? _residences : [_activeResidence!];

    for (final r in source) {
      for (final item in r.datesReservation) {
        final date = calParseApiDate(item.date);
        if (date == null || !calIsSameMonth(date, _visibleMonth)) continue;
        grouped.putIfAbsent(calFormatApiDate(date), () => []).add(r);
      }
    }

    final entries = grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return entries;
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadResidences();
  }

  // ── Data loading ──────────────────────────────────────────────────────────

  Future<void> _loadResidences() async {
    if (!mounted) return;
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      final loaded = <ResidenceModel>[];
      var page    = 1;
      var hasNext = true;

      while (hasNext && page <= 20) {
        final result = await LogmentRepository.getResidences(
          page: page,
          orderBy: 'createdAt',
          orderDir: OrderDir.desc.value,
        );
        loaded.addAll(result.data ?? []);
        hasNext = result.hasNext == true;
        page += 1;
      }

      final activeId   = _activeResidence?.id;
      ResidenceModel? nextActive;
      if (activeId != null) {
        for (final r in loaded) {
          if (r.id == activeId) { nextActive = r; break; }
        }
      }

      if (!mounted) return;
      setState(() {
        _residences      = loaded;
        _activeResidence = nextActive;
        _isLoading       = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() { _isLoading = false; _errorMessage = error.toString(); });
    }
  }

  // ── Block / Unblock ───────────────────────────────────────────────────────

  Future<bool> _blockDates(List<String> dateKeys, Set<String> residenceIds) async {
    if (dateKeys.isEmpty || residenceIds.isEmpty || _isSaving) return false;
    setState(() => _isSaving = true);

    try {
      final updatedNames = <String>[];
      var changed = false;

      for (final id in residenceIds) {
        final residence = _findById(id);
        if (residence == null) continue;
        final already  = _blockedKeysFor(residence);
        final pending  = dateKeys.where((d) => !already.contains(d)).toList();
        if (pending.isEmpty) continue;

        final resp = await LogmentRepository.addUnavailabilityDates(
          id: id, dates: pending,
        );
        _replaceResidence(resp.data);
        updatedNames.add(resp.data.nom.isNotEmpty ? resp.data.nom : residence.nom);
        changed = true;
      }

      if (!mounted) return false;
      setState(() { _selectionStart = null; _selectionEnd = null; _isSaving = false; });

      _showToast(changed
          ? 'Dates bloquées — ${calCompactNames(updatedNames)}'
          : 'Ces dates sont déjà bloquées');
      return changed;
    } catch (_) {
      if (mounted) setState(() => _isSaving = false);
      _showToast('Erreur réseau, réessayez', isError: true);
      return false;
    }
  }

  Future<bool> _unblockDates(List<String> dateKeys, Set<String> residenceIds) async {
    if (dateKeys.isEmpty || residenceIds.isEmpty || _isSaving) return false;
    setState(() => _isSaving = true);

    try {
      var changed = false;

      for (final id in residenceIds) {
        final residence = _findById(id);
        if (residence == null) continue;
        final already   = _blockedKeysFor(residence);
        final toRemove  = dateKeys.where((d) => already.contains(d)).toList();
        if (toRemove.isEmpty) continue;

        final resp = await LogmentRepository.removeUnavailabilityDates(
          id: id, dates: toRemove,
        );
        _replaceResidence(resp.data);
        changed = true;
      }

      if (!mounted) return false;
      setState(() => _isSaving = false);
      if (changed) _showToast('Dates débloquées avec succès');
      return changed;
    } catch (_) {
      if (mounted) setState(() => _isSaving = false);
      _showToast('Erreur réseau, réessayez', isError: true);
      return false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  ResidenceModel? _findById(String id) {
    for (final r in _residences) { if (r.id == id) return r; }
    return null;
  }

  void _replaceResidence(ResidenceModel updated) {
    final i = _residences.indexWhere((r) => r.id == updated.id);
    if (i >= 0) _residences[i] = updated;
    if (_activeResidence?.id == updated.id) _activeResidence = updated;
  }

  void _showToast(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: isError ? const Color(0xFFDC2626) : calInkColor,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        duration: const Duration(milliseconds: 2800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          message,
          style: calDmSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ));
  }

  void _checkAndShowTutorial(BuildContext ctx) async {
    if (_tutorialChecked) return;
    _tutorialChecked = true;
    final prefs  = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('calendar_tutorial_seen_v5') ?? false;
    if (!hasSeen) {
      if (!ShowcaseCoordinator.tryAcquire()) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ShowCaseWidget.of(ctx).startShowCase([_tutorialKey1, _tutorialKey2]);
          prefs.setBool('calendar_tutorial_seen_v5', true);
        } else {
          ShowcaseCoordinator.release();
        }
      });
    }
  }

  // ── Selection ─────────────────────────────────────────────────────────────

  void _clearSelection() =>
      setState(() { _selectionStart = null; _selectionEnd = null; });

  void _onDayTap(DateTime day) {
    final d = calDateOnly(day);
    if (calIsBeforeToday(d) || _isPanActive) return;

    final blocked = _blockedResidencesFor(d);
    if (blocked.isNotEmpty) {
      _clearSelection();
      showCalUnblockSheet(
        context: context,
        day: d,
        blockedResidences: blocked,
        isSaving: _isSaving,
        onUnblock: _unblockDates,
      );
      return;
    }

    if (_selectionStart != null && _selectionEnd != null &&
        calIsSameDay(_selectionStart!, d) && calIsSameDay(_selectionEnd!, d)) {
      _clearSelection();
      return;
    }

    setState(() { _selectionStart = d; _selectionEnd = d; });
    Future<void>.delayed(const Duration(milliseconds: 80), () {
      if (!mounted) return;
      _openBlockSheet();
    });
  }

  void _openBlockSheet() {
    showCalBlockSheet(
      context: context,
      dateKeys: _selectedDateKeys,
      selectionLabel: calFormatSelectionLong(_selectedRange),
      residences: _residences,
      activeResidence: _activeResidence,
      onBlock: _blockDates,
    ).then((_) {
      if (mounted) _clearSelection();
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: ShowcaseCoordinator.release,
      builder: (showcaseCtx) {
        return Scaffold(
          backgroundColor: calBackgroundColor,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                CalendarTopBar(
                  visibleMonth: _visibleMonth,
                  onPrevious: () => setState(
                    () => _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1),
                  ),
                  onNext: () => setState(
                    () => _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1),
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _buildContent(showcaseCtx),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext showcaseCtx) {
    if (_isLoading) {
      return const CalendarSkeleton(key: ValueKey('calendar-loading'));
    }

    if (_errorMessage != null) {
      return CalendarMessageState(
        key: const ValueKey('calendar-error'),
        icon: Iconsax.warning_2,
        title: 'Chargement impossible',
        message: "Nous n'avons pas pu récupérer vos résidences.",
        actionLabel: 'Réessayer',
        onAction: _loadResidences,
      );
    }

    if (_residences.isEmpty) {
      return CalendarMessageState(
        key: const ValueKey('calendar-empty'),
        icon: Iconsax.calendar_add,
        title: 'Aucune résidence',
        message: 'Ajoutez une résidence pour pouvoir bloquer ses dates de réservation.',
        actionLabel: 'Publier une résidence',
        onAction: () => context.go('/creations_v2'),
      );
    }

    _checkAndShowTutorial(showcaseCtx);

    return RefreshIndicator(
      key: const ValueKey('calendar-content'),
      color: calPrimaryColor,
      onRefresh: _loadResidences,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const Gap(12),
          ResidenceStrip(
            residences: _residences,
            activeResidence: _activeResidence,
            onSelect: (r) => setState(() => _activeResidence = r),
          ),
          const Gap(12),
          CalendarGrid(
            visibleDays: _visibleDays,
            visibleMonth: _visibleMonth,
            selectedRange: _selectedRange,
            today: _today,
            firstValidDay: _firstValidDay,
            tutorialKey1: _tutorialKey1,
            tutorialKey2: _tutorialKey2,
            blockedResidencesFor: _blockedResidencesFor,
            onDayTap: _onDayTap,
            onPanStart: (day) => setState(() {
              _isPanActive   = true;
              _selectionStart = day;
              _selectionEnd   = day;
            }),
            onPanUpdate: (day) => setState(() => _selectionEnd = day),
            onPanEnd: () {
              if (_selectedDateKeys.isNotEmpty) _openBlockSheet();
              setState(() => _isPanActive = false);
            },
          ),
          _buildSelectionPill(),
          BlockedDateSection(
            entries: _monthBlockedEntries,
            visibleMonth: _visibleMonth,
            onTap: (day, residences) => showCalUnblockSheet(
              context: context,
              day: day,
              blockedResidences: residences,
              isSaving: _isSaving,
              onUnblock: _unblockDates,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionPill() {
    final range = _selectedRange;
    if (range.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: calPrimarySoftColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            calFormatSelectionSummary(range),
            style: calDmSans(color: calPrimaryColor, fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
