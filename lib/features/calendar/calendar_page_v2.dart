import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class CalendarPageV2 extends StatefulWidget {
  const CalendarPageV2({super.key});

  static const name = 'CALENDAR_PAGE_V2';
  static const routePath = '/calendar_v2';

  @override
  State<CalendarPageV2> createState() => _CalendarPageV2State();
}

class _CalendarPageV2State extends State<CalendarPageV2> {
  static const _backgroundColor = Color(0xFFFFFFFF);
  static const _primaryColor = Color(0xFF2744DE);
  static const _primarySoftColor = Color(0xFFEEF1FD);
  static const _inkColor = Color(0xFF0F172A);
  static const _mutedColor = Color(0xFF94A3B8);
  static const _lineColor = Color(0xFFE2E8F0);
  static const _dangerColor = Color(0xFFEF4444);
  static const _dangerSoftColor = Color(0xFFFEF2F2);
  static const _warningSoftColor = Color(0xFFFFFBEB);
  static const _warningColor = Color(0xFFF59E0B);
  static const _monthNames = [
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'decembre',
  ];

  final _dayLabels = const ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  late DateTime _visibleMonth = _firstDayOfMonth(DateTime.now());
  List<ResidenceModel> _residences = [];
  ResidenceModel? _activeResidence;
  DateTime? _selectionStart;
  DateTime? _selectionEnd;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isPanActive = false;
  String? _errorMessage;

  final GlobalKey _tutorialKey1 = GlobalKey();
  final GlobalKey _tutorialKey2 = GlobalKey();
  bool _tutorialChecked = false;

  DateTime get _today => _dateOnly(DateTime.now());

  DateTime get _firstValidDay {
    try {
      return _visibleDays.firstWhere(
        (d) => !_isBeforeToday(d) && _blockedResidencesFor(d).isEmpty,
      );
    } catch (_) {
      return _today;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadResidences();
  }

  Future<void> _loadResidences() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final loaded = <ResidenceModel>[];
      var page = 1;
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

      final activeId = _activeResidence?.id;
      ResidenceModel? nextActive;
      if (activeId != null) {
        for (final residence in loaded) {
          if (residence.id == activeId) {
            nextActive = residence;
            break;
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _residences = loaded;
        _activeResidence = nextActive;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  Future<bool> _blockDates(
      List<String> dateKeys, Set<String> residenceIds) async {
    if (dateKeys.isEmpty || residenceIds.isEmpty || _isSaving) return false;

    setState(() => _isSaving = true);

    try {
      final updatedNames = <String>[];
      var changed = false;

      for (final residenceId in residenceIds) {
        final residence = _findResidenceById(residenceId);
        if (residence == null) continue;

        final alreadyBlocked = _blockedKeysForResidence(residence);
        final pendingDates =
            dateKeys.where((date) => !alreadyBlocked.contains(date)).toList();

        if (pendingDates.isEmpty) continue;

        final response = await LogmentRepository.addUnavailabilityDates(
          id: residenceId,
          dates: pendingDates,
        );
        _replaceResidence(response.data);
        updatedNames.add(
            response.data.nom.isNotEmpty ? response.data.nom : residence.nom);
        changed = true;
      }

      if (!mounted) return false;
      setState(() {
        _selectionStart = null;
        _selectionEnd = null;
        _isSaving = false;
      });

      if (changed) {
        _showToast(
          'Dates bloquées - ${_compactNames(updatedNames)}',
        );
      } else {
        _showToast('Ces dates sont déjà bloquées');
      }
      return changed;
    } catch (_) {
      if (mounted) setState(() => _isSaving = false);
      _showToast('Erreur réseau, réessayez', isError: true);
      return false;
    }
  }

  Future<bool> _unblockDates(
    List<String> dateKeys,
    Set<String> residenceIds,
  ) async {
    if (dateKeys.isEmpty || residenceIds.isEmpty || _isSaving) return false;

    setState(() => _isSaving = true);

    try {
      var changed = false;

      for (final residenceId in residenceIds) {
        final residence = _findResidenceById(residenceId);
        if (residence == null) continue;

        final alreadyBlocked = _blockedKeysForResidence(residence);
        final datesToRemove =
            dateKeys.where((date) => alreadyBlocked.contains(date)).toList();

        if (datesToRemove.isEmpty) continue;

        final response = await LogmentRepository.removeUnavailabilityDates(
          id: residenceId,
          dates: datesToRemove,
        );
        _replaceResidence(response.data);
        changed = true;
      }

      if (!mounted) return false;
      setState(() => _isSaving = false);

      if (changed) {
        _showToast('Dates débloquées avec succès');
      }
      return changed;
    } catch (_) {
      if (mounted) setState(() => _isSaving = false);
      _showToast('Erreur réseau, réessayez', isError: true);
      return false;
    }
  }

  ResidenceModel? _findResidenceById(String id) {
    for (final residence in _residences) {
      if (residence.id == id) return residence;
    }
    return null;
  }

  void _replaceResidence(ResidenceModel updatedResidence) {
    final index =
        _residences.indexWhere((item) => item.id == updatedResidence.id);
    if (index >= 0) {
      _residences[index] = updatedResidence;
    }
    if (_activeResidence?.id == updatedResidence.id) {
      _activeResidence = updatedResidence;
    }
  }

  void _showToast(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: isError ? const Color(0xFFDC2626) : _inkColor,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        duration: const Duration(milliseconds: 2800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          message,
          style: _dmSans(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
  }

  void _clearSelection() {
    setState(() {
      _selectionStart = null;
      _selectionEnd = null;
    });
  }

  void _onDayTap(DateTime day) {
    final normalizedDay = _dateOnly(day);
    if (_isBeforeToday(normalizedDay)) return;
    if (_isPanActive) return;

    final blockedResidences = _blockedResidencesFor(normalizedDay);
    if (blockedResidences.isNotEmpty) {
      _clearSelection();
      _showUnblockSheet(normalizedDay, blockedResidences);
      return;
    }

    // Tap on an already-single-selected day → deselect
    if (_selectionStart != null &&
        _selectionEnd != null &&
        _isSameDay(_selectionStart!, normalizedDay) &&
        _isSameDay(_selectionEnd!, normalizedDay)) {
      _clearSelection();
      return;
    }

    // For any tap, we just select this single day (resetting any range) and open sheet
    setState(() {
      _selectionStart = normalizedDay;
      _selectionEnd = normalizedDay;
    });

    Future<void>.delayed(const Duration(milliseconds: 80), () {
      if (!mounted) return;
      _showBlockSheet();
    });
  }

  void _handleDragSelection(Offset localPosition, Size size) {
    final day = _dayFromLocalPosition(localPosition, size);
    if (day == null || _isBeforeToday(day)) return;

    setState(() {
      _selectionStart ??= day;
      _selectionEnd = day;
    });
  }

  DateTime? _dayFromLocalPosition(Offset position, Size size) {
    if (position.dx < 0 ||
        position.dy < 0 ||
        position.dx > size.width ||
        position.dy > size.height) {
      return null;
    }

    final columnWidth = size.width / 7;
    final rowHeight = size.height / 6;
    final column = (position.dx / columnWidth).floor().clamp(0, 6);
    final row = (position.dy / rowHeight).floor().clamp(0, 5);
    final index = row * 7 + column;
    return _visibleDays[index];
  }

  Future<void> _showBlockSheet() async {
    final dateKeys = _selectedDateKeys;
    final selectedResidenceIds = <String>{};

    if (_activeResidence != null) {
      selectedResidenceIds.add(_activeResidence!.id);
    } else if (_residences.length == 1) {
      selectedResidenceIds.add(_residences.first.id);
    }

    var sheetSaving = false;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final hasDates = dateKeys.isNotEmpty;
            final canSubmit =
                hasDates && selectedResidenceIds.isNotEmpty && !sheetSaving;

            return _SheetFrame(
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.84,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _SheetHandle(),
                        _SheetHeader(
                          icon: Iconsax.lock,
                          iconColor: _primaryColor,
                          title: 'Bloquer des dates',
                          onClose: () => Navigator.of(sheetContext).pop(),
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SheetLabel('DATES'),
                                const Gap(8),
                                if (hasDates)
                                  _InfoPill(
                                    icon: Iconsax.calendar_1,
                                    text: _formatSelectionLong(),
                                    color: _primaryColor,
                                    backgroundColor: _primarySoftColor,
                                  )
                                else
                                  _InfoPill(
                                    icon: Iconsax.warning_2,
                                    text:
                                        'Sélectionnez des dates sur le calendrier',
                                    color: _warningColor,
                                    backgroundColor: _warningSoftColor,
                                  ),
                                const Gap(16),
                                _SheetLabel('RÉSIDENCE'),
                                const Gap(8),
                                if (_residences.length == 1)
                                  _ResidenceSelectorTile(
                                    residence: _residences.first,
                                    selected: true,
                                    locked: true,
                                    onTap: () {},
                                  )
                                else
                                  ..._residences.map(
                                    (residence) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: _ResidenceSelectorTile(
                                        residence: residence,
                                        selected: selectedResidenceIds
                                            .contains(residence.id),
                                        onTap: () {
                                          setSheetState(() {
                                            if (selectedResidenceIds
                                                .contains(residence.id)) {
                                              selectedResidenceIds
                                                  .remove(residence.id);
                                            } else {
                                              selectedResidenceIds
                                                  .add(residence.id);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                const Gap(8),
                                Row(
                                  children: [
                                    const Icon(
                                      Iconsax.info_circle,
                                      size: 13,
                                      color: _mutedColor,
                                    ),
                                    const Gap(6),
                                    Expanded(
                                      child: Text(
                                        'Ces dates ne seront plus réservables.',
                                        style: _dmSans(
                                          color: _mutedColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: _SheetButton(
                                  label: 'Annuler',
                                  onPressed: sheetSaving
                                      ? null
                                      : () => Navigator.of(sheetContext).pop(),
                                ),
                              ),
                              const Gap(8),
                              Expanded(
                                flex: 2,
                                child: _SheetButton(
                                  label: sheetSaving ? 'Blocage...' : 'Bloquer',
                                  filled: true,
                                  onPressed: canSubmit
                                      ? () async {
                                          setSheetState(() {
                                            sheetSaving = true;
                                          });
                                          final success = await _blockDates(
                                            dateKeys,
                                            selectedResidenceIds,
                                          );
                                          if (!sheetContext.mounted) return;
                                          if (success) {
                                            Navigator.of(sheetContext).pop();
                                          } else {
                                            setSheetState(() {
                                              sheetSaving = false;
                                            });
                                          }
                                        }
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showUnblockSheet(
    DateTime day,
    List<ResidenceModel> blockedResidences,
  ) async {
    final dateKeys = [_formatApiDate(day)];
    final selectedResidenceIds =
        blockedResidences.map((item) => item.id).toSet();
    var sheetSaving = false;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final canSubmit =
                selectedResidenceIds.isNotEmpty && !sheetSaving && !_isSaving;
            return _SheetFrame(
              topStripeColor: _dangerColor,
              child: SafeArea(
                top: false,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.78,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SheetHandle(),
                      _SheetHeader(
                        icon: Iconsax.lock_slash,
                        iconColor: _dangerColor,
                        title: 'Dates bloquées',
                        onClose: () => Navigator.of(sheetContext).pop(),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DetailLine(
                                icon: Iconsax.calendar_1,
                                label: 'Dates',
                                value: _formatDateLong(day),
                              ),
                              const Divider(
                                  height: 1, color: Color(0xFFF1F5F9)),
                              _DetailLine(
                                icon: Iconsax.house,
                                label: 'Résidences',
                                value: blockedResidences.length == 1
                                    ? blockedResidences.first.nom
                                    : '${blockedResidences.length} résidences',
                              ),
                              const Gap(16),
                              _SheetLabel('À DÉBLOQUER'),
                              const Gap(8),
                              ...blockedResidences.map(
                                (residence) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _ResidenceSelectorTile(
                                    residence: residence,
                                    selected: selectedResidenceIds
                                        .contains(residence.id),
                                    danger: true,
                                    locked: blockedResidences.length == 1,
                                    onTap: blockedResidences.length == 1
                                        ? () {}
                                        : () {
                                            setSheetState(() {
                                              if (selectedResidenceIds
                                                  .contains(residence.id)) {
                                                selectedResidenceIds
                                                    .remove(residence.id);
                                              } else {
                                                selectedResidenceIds
                                                    .add(residence.id);
                                              }
                                            });
                                          },
                                  ),
                                ),
                              ),
                              const Gap(6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Iconsax.info_circle,
                                    color: _mutedColor,
                                    size: 13,
                                  ),
                                  const Gap(6),
                                  Expanded(
                                    child: Text(
                                      'Ces dates redeviendront réservables par les clients.',
                                      style: _dmSans(
                                        color: _mutedColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _SheetButton(
                                label: 'Fermer',
                                onPressed: sheetSaving
                                    ? null
                                    : () => Navigator.of(sheetContext).pop(),
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              flex: 2,
                              child: _SheetButton(
                                label:
                                    sheetSaving ? 'Déblocage...' : 'Débloquer',
                                filled: true,
                                danger: true,
                                onPressed: canSubmit
                                    ? () async {
                                        final confirmed =
                                            await _confirmUnblockDialog(
                                          day: day,
                                          residenceNames: blockedResidences
                                              .where((residence) =>
                                                  selectedResidenceIds
                                                      .contains(residence.id))
                                              .map((residence) => residence.nom)
                                              .toList(),
                                        );

                                        if (!confirmed) return;
                                        setSheetState(() {
                                          sheetSaving = true;
                                        });
                                        final success = await _unblockDates(
                                          dateKeys,
                                          selectedResidenceIds,
                                        );
                                        if (!sheetContext.mounted) return;
                                        if (success) {
                                          Navigator.of(sheetContext).pop();
                                        } else {
                                          setSheetState(() {
                                            sheetSaving = false;
                                          });
                                        }
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _confirmUnblockDialog({
    required DateTime day,
    required List<String> residenceNames,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: _dangerSoftColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.lock_slash,
                    color: _dangerColor,
                    size: 26,
                  ),
                ),
                const Gap(14),
                Text(
                  'Débloquer ces dates ?',
                  textAlign: TextAlign.center,
                  style: _dmSans(
                    color: _inkColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(8),
                Text(
                  '${_formatDateLong(day)} - ${_compactNames(residenceNames)}',
                  textAlign: TextAlign.center,
                  style: _dmSans(
                    color: const Color(0xFF64748B),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(10),
                Text(
                  'Ces dates redeviendront réservables par les clients.',
                  textAlign: TextAlign.center,
                  style: _dmSans(
                    color: _mutedColor,
                    fontSize: 12,
                  ),
                ),
                const Gap(22),
                Row(
                  children: [
                    Expanded(
                      child: _SheetButton(
                        label: 'Annuler',
                        height: 44,
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: _SheetButton(
                        label: 'Débloquer',
                        height: 44,
                        filled: true,
                        danger: true,
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (showcaseContext) {
        return Scaffold(
          backgroundColor: _backgroundColor,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _buildContent(showcaseContext),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _checkAndShowTutorial(BuildContext context) async {
    if (_tutorialChecked) return;
    _tutorialChecked = true;
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('calendar_tutorial_seen_v5') ?? false;
    if (!hasSeen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ShowCaseWidget.of(context).startShowCase([_tutorialKey1, _tutorialKey2]);
          prefs.setBool('calendar_tutorial_seen_v5', true);
        }
      });
    }
  }

  Widget _buildTopBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _lineColor, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Column(
        children: [
          // Calendrier header supprimé
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MonthNavButton(
                icon: Iconsax.arrow_left_2,
                onTap: _goToPreviousMonth,
              ),
              const Gap(10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    child: child,
                  ),
                ),
                child: Text(
                  _monthTitle(_visibleMonth),
                  key: ValueKey(_visibleMonth.toIso8601String()),
                  style: _dmSans(
                    color: _inkColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Gap(10),
              _MonthNavButton(
                icon: Iconsax.arrow_right_3,
                onTap: _goToNextMonth,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return const _CalendarSkeleton(key: ValueKey('calendar-loading'));
    }

    if (_errorMessage != null) {
      return _CalendarMessageState(
        key: const ValueKey('calendar-error'),
        icon: Iconsax.warning_2,
        title: 'Chargement impossible',
        message: "Nous n'avons pas pu récupérer vos résidences.",
        actionLabel: 'Reessayer',
        onAction: _loadResidences,
      );
    }

    if (_residences.isEmpty) {
      return _CalendarMessageState(
        key: const ValueKey('calendar-empty'),
        icon: Iconsax.calendar_add,
        title: 'Aucune résidence',
        message: 'Ajoutez une résidence pour pouvoir bloquer ses dates de réservation.',
        actionLabel: 'Publier une résidence',
        onAction: () => context.go('/creations_v2'),
      );
    }

    _checkAndShowTutorial(context);

    return RefreshIndicator(
      key: const ValueKey('calendar-content'),
      color: _primaryColor,
      onRefresh: _loadResidences,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const Gap(12),
          _buildResidenceStrip(),
          const Gap(12),
          _buildCalendarPanel(),
          _buildSelectionPill(),
          _buildMonthBlockedSection(),
        ],
      ),
    );
  }

  Widget _buildResidenceStrip() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            final selected = _activeResidence == null;
            return _ResidenceFilterChip(
              label: 'Toutes',
              selected: selected,
              onTap: () => setState(() => _activeResidence = null),
            );
          }

          final residence = _residences[index - 1];
          return _ResidenceFilterChip(
            label: residence.nom.isEmpty ? 'Résidence' : residence.nom,
            selected: _activeResidence?.id == residence.id,
            imageId: residence.miniature,
            onTap: () => setState(() => _activeResidence = residence),
          );
        },
        separatorBuilder: (_, __) => const Gap(8),
        itemCount: _residences.length + 1,
      ),
    );
  }

  Widget _buildCalendarPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: _lineColor, width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          Row(
            children: _dayLabels
                .map(
                  (label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: _dmSans(
                          color: _mutedColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const Gap(8),
          AspectRatio(
            aspectRatio: 7 / 6,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                
                final int crossAxisCount = 7;
                final double crossAxisSpacing = 4;
                final double mainAxisSpacing = 4;
                final int rowCount = (_visibleDays.length / crossAxisCount).ceil();

                final double cellWidth = (size.width - (crossAxisCount - 1) * crossAxisSpacing) / crossAxisCount;
                final double cellHeight = (size.height - (rowCount - 1) * mainAxisSpacing) / rowCount;

                int rangeStart = _visibleDays.indexWhere((d) => !_isBeforeToday(d) && _blockedResidencesFor(d).isEmpty);
                if (rangeStart == -1) rangeStart = 0;
                rangeStart += 1;

                if (rangeStart % crossAxisCount > 4) {
                  rangeStart += (crossAxisCount - (rangeStart % crossAxisCount)); 
                }
                if (rangeStart + 2 >= _visibleDays.length) {
                  rangeStart = _visibleDays.length - 3;
                  if (rangeStart < 0) rangeStart = 0;
                }

                final int r = rangeStart ~/ crossAxisCount;
                final int c = rangeStart % crossAxisCount;

                final double top = r * (cellHeight + mainAxisSpacing);
                final double left = c * (cellWidth + crossAxisSpacing);
                final double width = (cellWidth * 3) + (crossAxisSpacing * 2);
                final double height = cellHeight;

                final grid = GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (details) {
                    final day = _dayFromLocalPosition(
                      details.localPosition,
                      size,
                    );
                    if (day == null || _isBeforeToday(day)) return;
                    setState(() {
                      _isPanActive = true;
                      _selectionStart = day;
                      _selectionEnd = day;
                    });
                  },
                  onPanUpdate: (details) {
                    _handleDragSelection(details.localPosition, size);
                  },
                  onPanEnd: (_) {
                    if (_selectedDateKeys.isNotEmpty) {
                      _showBlockSheet();
                    }
                    setState(() => _isPanActive = false);
                  },
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: _visibleDays.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      final day = _visibleDays[index];
                      return _buildDayCell(day);
                    },
                  ),
                );

                return Stack(
                  children: [
                    grid,
                    Positioned(
                      top: top,
                      left: left,
                      width: width,
                      height: height,
                      child: Showcase(
                        key: _tutorialKey2,
                        description: 'Maintenez et glissez votre doigt sur plusieurs dates pour sélectionner une période.',
                        tooltipBackgroundColor: Colors.white,
                        textColor: _inkColor,
                        descTextStyle: _dmSans(color: _inkColor, fontWeight: FontWeight.w600),
                        targetBorderRadius: BorderRadius.circular(8),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(DateTime day) {
    final inMonth = _isSameMonth(day, _visibleMonth);
    final isToday = _isSameDay(day, _today);
    final isPast = _isBeforeToday(day);
    final blockedResidences = _blockedResidencesFor(day);
    final isBlocked = blockedResidences.isNotEmpty;
    final isSelected = _isDateSelected(day);
    final isSingleSelection = _selectedRange.length == 1 && isSelected;
    final isRangeStart = _isRangeStart(day);
    final isRangeEnd = _isRangeEnd(day);
    final isRangeMiddle =
        isSelected && !isSingleSelection && !isRangeStart && !isRangeEnd;

    Color background = Colors.transparent;
    Color textColor = inMonth ? _inkColor : const Color(0xFFCBD5E1);
    FontWeight fontWeight = FontWeight.w600;
    BorderRadius borderRadius = BorderRadius.circular(8);

    if (isBlocked && !isSelected) {
      background = _dangerSoftColor;
      textColor = _dangerColor;
    }

    if (isRangeMiddle) {
      background = _primarySoftColor;
      textColor = const Color(0xFF1A30A8);
      borderRadius = BorderRadius.zero;
    }

    if (isRangeStart && !isSingleSelection) {
      background = _primaryColor;
      textColor = Colors.white;
      borderRadius = const BorderRadius.horizontal(left: Radius.circular(8));
    }

    if (isRangeEnd && !isSingleSelection) {
      background = _primaryColor;
      textColor = Colors.white;
      borderRadius = const BorderRadius.horizontal(right: Radius.circular(8));
    }

    if (isSingleSelection) {
      background = _primarySoftColor;
      textColor = _primaryColor;
      borderRadius = BorderRadius.circular(8);
    }

    if (isToday && !isSelected && !isBlocked) {
      textColor = _primaryColor;
      fontWeight = FontWeight.w800;
    }

    if (isPast && !isBlocked && !isSelected) {
      textColor = const Color(0xFFCBD5E1);
      fontWeight = FontWeight.w500;
    }

    Widget cell = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onDayTap(day),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: background,
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: _dmSans(
                color: textColor,
                fontSize: 13,
                fontWeight: fontWeight,
              ),
            ),
            const Gap(4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: (isBlocked || (isToday && !isSelected)) ? 5 : 0,
              height: (isBlocked || (isToday && !isSelected)) ? 5 : 0,
              decoration: BoxDecoration(
                color: isBlocked ? _dangerColor : _primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );

    if (_isSameDay(day, _firstValidDay)) {
      return Showcase(
        key: _tutorialKey1,
        description: '💡 Astuce : Touchez une date pour la bloquer.',
        tooltipBackgroundColor: Colors.white,
        textColor: _inkColor,
        descTextStyle: _dmSans(color: _inkColor, fontWeight: FontWeight.w600),
        targetBorderRadius: BorderRadius.circular(8),
        child: cell,
      );
    }

    return cell;
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
            color: _primarySoftColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _formatSelectionSummary(),
            style: _dmSans(
              color: _primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthBlockedSection() {
    final entries = _monthBlockedEntries;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Dates bloquées ce mois',
                style: _dmSans(
                  color: _inkColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '${entries.length}',
                style: _dmSans(
                  color: _mutedColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Gap(10),
          if (entries.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _lineColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: _primarySoftColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.calendar_tick,
                      color: _primaryColor,
                      size: 18,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      'Aucune residence marque indisponible',
                      style: _dmSans(
                        color: const Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ...entries.take(6).map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _BlockedDateTile(
                      date: _parseApiDate(entry.key) ?? _visibleMonth,
                      residences: entry.value,
                      onTap: () {
                        final day = _parseApiDate(entry.key);
                        if (day == null) return;
                        _showUnblockSheet(day, entry.value);
                      },
                    ),
                  ),
                ),
          if (entries.length > 6)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '+ ${entries.length - 6} autres dates sur le calendrier',
                style: _dmSans(
                  color: _mutedColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<MapEntry<String, List<ResidenceModel>>> get _monthBlockedEntries {
    final grouped = <String, List<ResidenceModel>>{};
    final source = _activeResidence == null
        ? _residences
        : <ResidenceModel>[_activeResidence!];

    for (final residence in source) {
      for (final item in residence.datesReservation) {
        final date = _parseApiDate(item.date);
        if (date == null || !_isSameMonth(date, _visibleMonth)) continue;
        final key = _formatApiDate(date);
        grouped.putIfAbsent(key, () => []).add(residence);
      }
    }

    final entries = grouped.entries.toList();
    entries.sort((a, b) => a.key.compareTo(b.key));
    return entries;
  }

  List<DateTime> get _visibleDays {
    final firstDay = _firstDayOfMonth(_visibleMonth);
    final offset = firstDay.weekday - DateTime.monday;
    final gridStart = firstDay.subtract(Duration(days: offset));
    return List.generate(42, (index) => gridStart.add(Duration(days: index)));
  }

  List<DateTime> get _selectedRange {
    if (_selectionStart == null) return [];
    final start = _dateOnly(_selectionStart!);
    final end = _dateOnly(_selectionEnd ?? _selectionStart!);
    final from = start.isBefore(end) ? start : end;
    final to = start.isBefore(end) ? end : start;
    final days = to.difference(from).inDays + 1;
    return List.generate(days, (index) => from.add(Duration(days: index)));
  }

  List<String> get _selectedDateKeys =>
      _selectedRange.map(_formatApiDate).toSet().toList()..sort();

  bool _isDateSelected(DateTime day) {
    final key = _formatApiDate(day);
    return _selectedDateKeys.contains(key);
  }

  bool _isRangeStart(DateTime day) {
    final range = _selectedRange;
    if (range.isEmpty) return false;
    return _isSameDay(range.first, day);
  }

  bool _isRangeEnd(DateTime day) {
    final range = _selectedRange;
    if (range.isEmpty) return false;
    return _isSameDay(range.last, day);
  }

  bool _isBeforeToday(DateTime day) => _dateOnly(day).isBefore(_today);

  List<ResidenceModel> _blockedResidencesFor(DateTime day) {
    final key = _formatApiDate(day);
    final source = _activeResidence == null
        ? _residences
        : <ResidenceModel>[_activeResidence!];
    return source
        .where((residence) => _blockedKeysForResidence(residence).contains(key))
        .toList();
  }

  Set<String> _blockedKeysForResidence(ResidenceModel residence) {
    return residence.datesReservation
        .map((item) => _parseApiDate(item.date))
        .whereType<DateTime>()
        .map(_formatApiDate)
        .toSet();
  }

  String _formatSelectionSummary() {
    final range = _selectedRange;
    if (range.isEmpty) return '';
    if (range.length == 1) return _formatDateLong(range.first);
    final first = range.first;
    final last = range.last;
    final daysLabel = range.length == 1 ? 'jour' : 'jours';

    if (first.year == last.year && first.month == last.month) {
      return '${first.day} - ${last.day} ${_monthNames[first.month - 1]} - ${range.length} $daysLabel';
    }
    return '${_formatDateShort(first)} - ${_formatDateShort(last)} - ${range.length} $daysLabel';
  }

  String _formatSelectionLong() {
    final range = _selectedRange;
    if (range.isEmpty) return '';
    if (range.length == 1) return _formatDateLong(range.first);

    final first = range.first;
    final last = range.last;
    if (first.year == last.year && first.month == last.month) {
      return '${first.day} - ${last.day} ${_monthNames[first.month - 1]} ${first.year}';
    }
    return '${_formatDateLong(first)} - ${_formatDateLong(last)}';
  }

  static String _compactNames(List<String> names) {
    final cleanNames = names.where((name) => name.trim().isNotEmpty).toList();
    if (cleanNames.isEmpty) return 'Résidence';
    if (cleanNames.length == 1) return cleanNames.first;
    if (cleanNames.length == 2) {
      return '${cleanNames.first}, ${cleanNames.last}';
    }
    return '${cleanNames.first} + ${cleanNames.length - 1}';
  }

  static String _monthTitle(DateTime date) {
    final month = _monthNames[date.month - 1];
    return '${month[0].toUpperCase()}${month.substring(1)} ${date.year}';
  }

  static String _formatDateLong(DateTime date) =>
      '${date.day} ${_monthNames[date.month - 1]} ${date.year}';

  static String _formatDateShort(DateTime date) =>
      '${date.day} ${_monthNames[date.month - 1]}';

  static String _formatApiDate(DateTime date) {
    final normalized = _dateOnly(date);
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '${normalized.year}-$month-$day';
  }

  static DateTime? _parseApiDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return _dateOnly(parsed);
    }

    final parts = value.split(RegExp(r'[-/]'));
    if (parts.length < 3) return null;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return null;
    return DateTime(year, month, day);
  }

  static DateTime _firstDayOfMonth(DateTime date) =>
      DateTime(date.year, date.month);

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool _isSameDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  static bool _isSameMonth(DateTime first, DateTime second) =>
      first.year == second.year && first.month == second.month;

  static TextStyle _dmSans({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
  }) {
    return GoogleFonts.dmSans(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: 0,
    );
  }
}

class _MonthNavButton extends StatelessWidget {
  const _MonthNavButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        width: 34,
        height: 30,
        child: Icon(
          icon,
          color: _CalendarPageV2State._inkColor,
          size: 18,
        ),
      ),
    );
  }
}

class _ResidenceFilterChip extends StatelessWidget {
  const _ResidenceFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.imageId,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? imageId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        constraints: const BoxConstraints(maxWidth: 210),
        padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
        decoration: BoxDecoration(
          color:
              selected ? _CalendarPageV2State._primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? _CalendarPageV2State._primaryColor
                : _CalendarPageV2State._lineColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ResidenceAvatar(imageId: imageId, selected: selected),
            const Gap(7),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _CalendarPageV2State._dmSans(
                  color: selected
                      ? Colors.white
                      : const Color(0xFF475569),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResidenceSelectorTile extends StatelessWidget {
  const _ResidenceSelectorTile({
    required this.residence,
    required this.selected,
    required this.onTap,
    this.locked = false,
    this.danger = false,
  });

  final ResidenceModel residence;
  final bool selected;
  final VoidCallback onTap;
  final bool locked;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final accent = danger
        ? _CalendarPageV2State._dangerColor
        : _CalendarPageV2State._primaryColor;
    final soft = danger
        ? _CalendarPageV2State._dangerSoftColor
        : _CalendarPageV2State._primarySoftColor;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: locked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? soft : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? accent : _CalendarPageV2State._lineColor,
          ),
        ),
        child: Row(
          children: [
            _ResidenceAvatar(
              imageId: residence.miniature,
              selected: selected,
              size: 36,
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    residence.nom.isEmpty ? 'Résidence' : residence.nom,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _CalendarPageV2State._dmSans(
                      color: _CalendarPageV2State._inkColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    residence.commune.isEmpty
                        ? residence.ville
                        : residence.commune,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _CalendarPageV2State._dmSans(
                      color: _CalendarPageV2State._mutedColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: selected ? accent : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: selected ? accent : _CalendarPageV2State._lineColor,
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResidenceAvatar extends StatelessWidget {
  const _ResidenceAvatar({
    this.imageId,
    this.selected = false,
    this.size = 28,
  });

  final String? imageId;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageId != null && imageId!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(size <= 28 ? 14 : 8),
      child: Container(
        width: size,
        height: size,
        color: const Color(0xFFF1F5F9),
        child: hasImage
            ? Image(
                image: CachedNetworkImageProvider(
                  Utils.getImagePath(id: imageId!),
                ),
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/img/residence_default.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _BlockedDateTile extends StatelessWidget {
  const _BlockedDateTile({
    required this.date,
    required this.residences,
    required this.onTap,
  });

  final DateTime date;
  final List<ResidenceModel> residences;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _CalendarPageV2State._lineColor),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _CalendarPageV2State._dangerSoftColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Iconsax.lock,
                color: _CalendarPageV2State._dangerColor,
                size: 18,
              ),
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _CalendarPageV2State._formatDateLong(date),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _CalendarPageV2State._dmSans(
                      color: _CalendarPageV2State._inkColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    _CalendarPageV2State._compactNames(
                      residences.map((residence) => residence.nom).toList(),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _CalendarPageV2State._dmSans(
                      color: const Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Iconsax.arrow_right_3,
              color: _CalendarPageV2State._mutedColor,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({
    required this.child,
    this.topStripeColor,
  });

  final Widget child;
  final Color? topStripeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (topStripeColor != null)
            Container(
              width: double.infinity,
              height: 4,
              color: topStripeColor,
            ),
          child,
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: _CalendarPageV2State._lineColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onClose,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: _CalendarPageV2State._lineColor)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const Gap(8),
          Expanded(
            child: Text(
              title,
              style: _CalendarPageV2State._dmSans(
                color: _CalendarPageV2State._inkColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onClose,
            icon: const Icon(
              Icons.close,
              color: _CalendarPageV2State._mutedColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetLabel extends StatelessWidget {
  const _SheetLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: _CalendarPageV2State._dmSans(
        color: _CalendarPageV2State._mutedColor,
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.text,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const Gap(6),
          Flexible(
            child: Text(
              text,
              style: _CalendarPageV2State._dmSans(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: _CalendarPageV2State._mutedColor, size: 18),
          const Gap(10),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: _CalendarPageV2State._dmSans(
                color: const Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _CalendarPageV2State._dmSans(
                color: _CalendarPageV2State._inkColor,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.onPressed,
    this.filled = false,
    this.danger = false,
    this.height = 48,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final bool danger;
  final double height;

  @override
  Widget build(BuildContext context) {
    final accent = danger
        ? _CalendarPageV2State._dangerColor
        : _CalendarPageV2State._primaryColor;

    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: filled ? accent : Colors.white,
          disabledBackgroundColor:
              filled ? accent.withValues(alpha: 0.4) : Colors.white,
          foregroundColor: filled ? Colors.white : const Color(0xFF64748B),
          disabledForegroundColor: filled
              ? Colors.white.withValues(alpha: 0.9)
              : const Color(0xFFCBD5E1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color:
                  filled ? Colors.transparent : _CalendarPageV2State._lineColor,
            ),
          ),
          textStyle: _CalendarPageV2State._dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _CalendarSkeleton extends StatelessWidget {
  const _CalendarSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Row(
          children: List.generate(
            3,
            (index) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index == 2 ? 0 : 8),
                child: const _SkeletonBox(height: 38, radius: 22),
              ),
            ),
          ),
        ),
        const Gap(16),
        Container(
          padding: const EdgeInsets.all(14),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: List.generate(
                  7,
                  (_) => const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: _SkeletonBox(height: 12, radius: 6),
                    ),
                  ),
                ),
              ),
              const Gap(12),
              AspectRatio(
                aspectRatio: 7 / 6,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 42,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (_, __) =>
                      const _SkeletonBox(height: 40, radius: 8),
                ),
              ),
            ],
          ),
        ),
        const Gap(22),
        const _SkeletonBox(height: 62, radius: 12),
        const Gap(10),
        const _SkeletonBox(height: 62, radius: 12),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.height,
    required this.radius,
  });

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _CalendarMessageState extends StatelessWidget {
  const _CalendarMessageState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: _CalendarPageV2State._primarySoftColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: _CalendarPageV2State._primaryColor,
                size: 28,
              ),
            ),
            const Gap(14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: _CalendarPageV2State._dmSans(
                color: _CalendarPageV2State._inkColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Gap(6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: _CalendarPageV2State._dmSans(
                color: const Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
            const Gap(18),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: _CalendarPageV2State._primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: _CalendarPageV2State._dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
