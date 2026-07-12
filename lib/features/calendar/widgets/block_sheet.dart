import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';

import '../calendar_theme.dart';
import 'calendar_ui_widgets.dart';

/// Shows the "Bloquer des dates" bottom sheet.
///
/// [dateKeys]         : list of 'yyyy-MM-dd' strings to block.
/// [selectionLabel]   : human-readable summary shown in the date pill.
/// [residences]       : all available residences to select from.
/// [activeResidence]  : pre-selected residence (if any).
/// [onBlock]          : callback that performs the actual blocking;
///                      returns true on success.
Future<void> showCalBlockSheet({
  required BuildContext context,
  required List<String> dateKeys,
  required String selectionLabel,
  required List<ResidenceModel> residences,
  required ResidenceModel? activeResidence,
  required Future<bool> Function(
    List<String> dateKeys,
    Set<String> residenceIds,
  ) onBlock,
}) async {
  final selectedIds = <String>{};
  if (activeResidence != null) {
    selectedIds.add(activeResidence.id);
  } else if (residences.length == 1) {
    selectedIds.add(residences.first.id);
  }

  var sheetSaving = false;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    isScrollControlled: true,
    builder: (sheetCtx) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final hasDates  = dateKeys.isNotEmpty;
          final canSubmit = hasDates && selectedIds.isNotEmpty && !sheetSaving;

          return CalSheetFrame(
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
                      const CalSheetHandle(),
                      CalSheetHeader(
                        icon: Iconsax.lock,
                        iconColor: calPrimaryColor,
                        title: 'Bloquer des dates',
                        onClose: () => Navigator.of(sheetCtx).pop(),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CalSheetLabel('DATES'),
                              const Gap(8),
                              if (hasDates)
                                CalInfoPill(
                                  icon: Iconsax.calendar_1,
                                  text: selectionLabel,
                                  color: calPrimaryColor,
                                  backgroundColor: calPrimarySoftColor,
                                )
                              else
                                CalInfoPill(
                                  icon: Iconsax.warning_2,
                                  text: 'Sélectionnez des dates sur le calendrier',
                                  color: calWarningColor,
                                  backgroundColor: calWarningSoftColor,
                                ),
                              const Gap(16),
                              const CalSheetLabel('RÉSIDENCE'),
                              const Gap(8),
                              if (residences.length == 1)
                                CalResidenceSelectorTile(
                                  residence: residences.first,
                                  selected: true,
                                  locked: true,
                                  onTap: () {},
                                )
                              else
                                ...residences.map(
                                  (r) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: CalResidenceSelectorTile(
                                      residence: r,
                                      selected: selectedIds.contains(r.id),
                                      onTap: () {
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
                              const Gap(8),
                              Row(
                                children: [
                                  const Icon(Iconsax.info_circle, size: 13, color: calMutedColor),
                                  const Gap(6),
                                  Expanded(
                                    child: Text(
                                      'Ces dates ne seront plus réservables.',
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
                                label: 'Annuler',
                                onPressed: sheetSaving
                                    ? null
                                    : () => Navigator.of(sheetCtx).pop(),
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              flex: 2,
                              child: CalSheetButton(
                                label: sheetSaving ? 'Blocage...' : 'Bloquer',
                                filled: true,
                                onPressed: canSubmit
                                    ? () async {
                                        setSheetState(() => sheetSaving = true);
                                        final ok = await onBlock(dateKeys, selectedIds);
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
            ),
          );
        },
      );
    },
  );
}
