import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';

import '../calendar_date_utils.dart';
import '../calendar_theme.dart';
import 'calendar_ui_widgets.dart';

/// Shows the "Dates bloquées / Débloquer" bottom sheet for a single [day].
///
/// [blockedResidences] : residences that are blocked on [day].
/// [isSaving]          : whether a save is already in progress (disables submit).
/// [onUnblock]         : callback that performs the actual unblocking;
///                       returns true on success.
Future<void> showCalUnblockSheet({
  required BuildContext context,
  required DateTime day,
  required List<ResidenceModel> blockedResidences,
  required bool isSaving,
  required Future<bool> Function(
    List<String> dateKeys,
    Set<String> residenceIds,
  ) onUnblock,
}) async {
  final dateKeys     = [calFormatApiDate(day)];
  final selectedIds  = blockedResidences.map((r) => r.id).toSet();
  var sheetSaving    = false;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    isScrollControlled: true,
    builder: (sheetCtx) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final canSubmit = selectedIds.isNotEmpty && !sheetSaving && !isSaving;

          return CalSheetFrame(
            topStripeColor: calDangerColor,
            child: SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.78,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CalSheetHandle(),
                    CalSheetHeader(
                      icon: Iconsax.lock_slash,
                      iconColor: calDangerColor,
                      title: 'Dates bloquées',
                      onClose: () => Navigator.of(sheetCtx).pop(),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CalDetailLine(
                              icon: Iconsax.calendar_1,
                              label: 'Dates',
                              value: calFormatDateLong(day),
                            ),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            CalDetailLine(
                              icon: Iconsax.house,
                              label: 'Résidences',
                              value: blockedResidences.length == 1
                                  ? blockedResidences.first.nom
                                  : '${blockedResidences.length} résidences',
                            ),
                            const Gap(16),
                            const CalSheetLabel('À DÉBLOQUER'),
                            const Gap(8),
                            ...blockedResidences.map(
                              (r) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: CalResidenceSelectorTile(
                                  residence: r,
                                  selected: selectedIds.contains(r.id),
                                  danger: true,
                                  locked: blockedResidences.length == 1,
                                  onTap: blockedResidences.length == 1
                                      ? () {}
                                      : () {
                                          setSheetState(() {
                                            if (selectedIds.contains(r.id)) {
                                              selectedIds.remove(r.id);
                                            } else {
                                              selectedIds.add(r.id);
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
                                const Icon(Iconsax.info_circle, color: calMutedColor, size: 13),
                                const Gap(6),
                                Expanded(
                                  child: Text(
                                    'Ces dates redeviendront réservables par les clients.',
                                    style: calDmSans(color: calMutedColor, fontSize: 12),
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
                            child: CalSheetButton(
                              label: 'Fermer',
                              onPressed: sheetSaving
                                  ? null
                                  : () => Navigator.of(sheetCtx).pop(),
                            ),
                          ),
                          const Gap(8),
                          Expanded(
                            flex: 2,
                            child: CalSheetButton(
                              label: sheetSaving ? 'Déblocage...' : 'Débloquer',
                              filled: true,
                              danger: true,
                              onPressed: canSubmit
                                  ? () async {
                                      final confirmed = await showCalConfirmUnblockDialog(
                                        context: context,
                                        day: day,
                                        residenceNames: blockedResidences
                                            .where((r) => selectedIds.contains(r.id))
                                            .map((r) => r.nom)
                                            .toList(),
                                      );
                                      if (!confirmed) return;
                                      setSheetState(() => sheetSaving = true);
                                      final ok = await onUnblock(dateKeys, selectedIds);
                                      if (!sheetCtx.mounted) return;
                                      if (ok) {
                                        Navigator.of(sheetCtx).pop();
                                      } else {
                                        setSheetState(() => sheetSaving = false);
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

// ── Confirm dialog ───────────────────────────────────────────────────────────

/// Shows a confirmation dialog before unblocking dates.
/// Returns true if the user confirmed.
Future<bool> showCalConfirmUnblockDialog({
  required BuildContext context,
  required DateTime day,
  required List<String> residenceNames,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    builder: (dialogCtx) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: calDangerSoftColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Iconsax.lock_slash, color: calDangerColor, size: 26),
              ),
              const Gap(14),
              Text(
                'Débloquer ces dates ?',
                textAlign: TextAlign.center,
                style: calDmSans(color: calInkColor, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const Gap(8),
              Text(
                '${calFormatDateLong(day)} — ${calCompactNames(residenceNames)}',
                textAlign: TextAlign.center,
                style: calDmSans(
                  color: const Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(10),
              Text(
                'Ces dates redeviendront réservables par les clients.',
                textAlign: TextAlign.center,
                style: calDmSans(color: calMutedColor, fontSize: 12),
              ),
              const Gap(22),
              Row(
                children: [
                  Expanded(
                    child: CalSheetButton(
                      label: 'Annuler',
                      height: 44,
                      onPressed: () => Navigator.of(dialogCtx).pop(false),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: CalSheetButton(
                      label: 'Débloquer',
                      height: 44,
                      filled: true,
                      danger: true,
                      onPressed: () => Navigator.of(dialogCtx).pop(true),
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
