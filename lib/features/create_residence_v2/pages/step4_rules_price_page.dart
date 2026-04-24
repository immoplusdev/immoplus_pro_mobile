import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_residence_v2/logic/residence_creation_cubit_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/creation_navigation_buttons_v2.dart';
import 'package:immoplus_pro/gen/assets.gen.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';

class Step4RulesPricePage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step4RulesPricePage({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step4RulesPricePage> createState() => _Step4RulesPricePageState();
}

class _Step4RulesPricePageState extends State<Step4RulesPricePage> {
  late TextEditingController _prixController;

  @override
  void initState() {
    super.initState();
    final currentPrix =
        context.read<ResidenceCreationCubitV2>().state.prixReservation;
    _prixController = TextEditingController(
      text: currentPrix > 0 ? currentPrix.toString() : '',
    );
  }

  @override
  void dispose() {
    _prixController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimePicker(
                  context,
                  title: "Heure à partir de laquelle le client peut venir",
                  timeSelector: (state) => state.heureEntree,
                  onUpdate: (time) => context
                      .read<ResidenceCreationCubitV2>()
                      .updateHeures(time, time), // Both set to the same time
                ),
                const Gap(15),
                _buildTimePicker(
                  context,
                  title: "Heure de sortie du client",
                  timeSelector: (state) => state.heureDepart,
                  onUpdate: null, // Disabled selector
                  isDisabled: true,
                ),
                const Gap(25),
                const Text("Durée minimum de séjour :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(10),
                _buildDurationCounter(
                  context,
                  valueSelector: (state) => state.dureeMinSejour,
                  onAdd: () {
                    final state =
                        context.read<ResidenceCreationCubitV2>().state;
                    context.read<ResidenceCreationCubitV2>().updateDurees(
                        state.dureeMinSejour + 1, state.dureeMaxSejour);
                  },
                  onRemove: () {
                    final state =
                        context.read<ResidenceCreationCubitV2>().state;
                    if (state.dureeMinSejour > 0) {
                      context.read<ResidenceCreationCubitV2>().updateDurees(
                          state.dureeMinSejour - 1, state.dureeMaxSejour);
                    }
                  },
                ),
                const Gap(15),
                const Text("Durée maximum de séjour :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(10),
                _buildDurationCounter(
                  context,
                  valueSelector: (state) => state.dureeMaxSejour,
                  onAdd: () {
                    final state =
                        context.read<ResidenceCreationCubitV2>().state;
                    context.read<ResidenceCreationCubitV2>().updateDurees(
                        state.dureeMinSejour, state.dureeMaxSejour + 1);
                  },
                  onRemove: () {
                    final state =
                        context.read<ResidenceCreationCubitV2>().state;
                    if (state.dureeMaxSejour > 0) {
                      context.read<ResidenceCreationCubitV2>().updateDurees(
                          state.dureeMinSejour, state.dureeMaxSejour - 1);
                    }
                  },
                ),
                const Gap(25),
                _buildToggleRule(
                  context,
                  title: "Les animaux sont-ils autorisés ?",
                  valueSelector: (state) => state.animauxAutorises,
                  onToggle: (val) {
                    final s = context.read<ResidenceCreationCubitV2>().state;
                    context.read<ResidenceCreationCubitV2>().updateRegles(val,
                        s.fetesAutorises, s.reglesSupplementaires.isNotEmpty);
                  },
                ),
                const Gap(15),
                _buildToggleRule(
                  context,
                  title: "Les fêtes sont-elles autorisées ?",
                  valueSelector: (state) => state.fetesAutorises,
                  onToggle: (val) {
                    final s = context.read<ResidenceCreationCubitV2>().state;
                    context.read<ResidenceCreationCubitV2>().updateRegles(
                        s.animauxAutorises,
                        val,
                        s.reglesSupplementaires.isNotEmpty);
                  },
                ),
                const Gap(15),
                _buildToggleRule(
                  context,
                  title: "Éviter le bruit",
                  valueSelector: (state) =>
                      state.reglesSupplementaires == "Éviter le bruit",
                  onToggle: (val) {
                    final s = context.read<ResidenceCreationCubitV2>().state;
                    context.read<ResidenceCreationCubitV2>().updateRegles(
                        s.animauxAutorises, s.fetesAutorises, val);
                  },
                ),
                const Gap(25),
                const Text("Prix du séjour par jour :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(10),
                TextField(
                  controller: _prixController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final prix = int.tryParse(val) ?? 0;
                    context.read<ResidenceCreationCubitV2>().updatePrix(prix);
                  },
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 20, top: 16),
                      child: Text("fcfa",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ),
                const Gap(40),
              ],
            ),
          ),
        ),
        BlocBuilder<ResidenceCreationCubitV2, ResidenceCreationStateV2>(
          builder: (context, state) {
            final isValid = state.prixReservation > 0 &&
                state.dureeMinSejour > 0 &&
                state.dureeMaxSejour > 0 &&
                state.heureEntree.isNotEmpty;

            return CreationNavigationButtonsV2(
              onPrevious: widget.onPrevious,
              onNext: isValid
                  ? () {
                      if (state.dureeMinSejour >= state.dureeMaxSejour) {
                        ToastUtils.showError(
                          description:
                              "La durée minimum doit être inférieure à la durée maximum",
                        );
                        return;
                      }
                      widget.onNext();
                    }
                  : null,
              onSave: isValid
                  ? () {
                      if (state.dureeMinSejour >= state.dureeMaxSejour) {
                        ToastUtils.showError(
                          description:
                              "La durée minimum doit être inférieure à la durée maximum",
                        );
                        return;
                      }
                      context.read<ResidenceCreationCubitV2>().submit();
                    }
                  : null,
              saveText: state.id != null
                  ? "Enregistrer les modifications"
                  : "Finaliser et publier",
              showNext: state.id != null,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context,
      {required String title,
      required String Function(ResidenceCreationStateV2) timeSelector,
      required Function(String)? onUpdate,
      bool isDisabled = false}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE), shape: BoxShape.circle),
          child: Center(
              child: SvgPicture.asset(
            Assets.svgs.house,
            width: 20,
          )),
        ),
        const Gap(15),
        Expanded(
          child: InkWell(
            onTap: isDisabled
                ? null
                : () async {
                    final currentState =
                        context.read<ResidenceCreationCubitV2>().state;
                    final currentTimeStr = timeSelector(currentState);
                    TimeOfDay initial;
                    try {
                      final parts = currentTimeStr.split(':');
                      initial = TimeOfDay(
                          hour: int.parse(parts[0]),
                          minute: int.parse(parts[1]));
                    } catch (_) {
                      initial = const TimeOfDay(hour: 6, minute: 0);
                    }

                    final time = await showTimePicker(
                      context: context,
                      initialTime: initial,
                    );
                    if (time != null) {
                      final format =
                          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                      if (onUpdate != null) {
                        onUpdate(format);
                      }
                    }
                  },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ResidenceCreationCubitV2, ResidenceCreationStateV2>(
                  buildWhen: (p, c) => timeSelector(p) != timeSelector(c),
                  builder: (context, state) {
                    final timeStr = timeSelector(state);
                    return Text(
                      timeStr.isEmpty ? "Choisir" : timeStr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: isDisabled ? Colors.grey : Colors.black87,
                      ),
                    );
                  },
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationCounter(BuildContext context,
      {required int Function(ResidenceCreationStateV2) valueSelector,
      required VoidCallback onAdd,
      required VoidCallback onRemove}) {
    return Row(
      children: [
        BlocBuilder<ResidenceCreationCubitV2, ResidenceCreationStateV2>(
          buildWhen: (p, c) => valueSelector(p) != valueSelector(c),
          builder: (context, state) {
            return Text(
              valueSelector(state).toString().padLeft(2, '0'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            );
          },
        ),
        const Gap(15),
        const Expanded(
          child: Text(
            "Jours",
            style: TextStyle(fontSize: 14),
          ),
        ),
        InkWell(
          onTap: onRemove,
          child: Icon(Icons.remove_circle, color: AppColors.primary, size: 28),
        ),
        const Gap(10),
        InkWell(
          onTap: onAdd,
          child: Icon(Icons.add_circle, color: AppColors.primary, size: 28),
        ),
      ],
    );
  }

  Widget _buildToggleRule(BuildContext context,
      {required String title,
      required bool Function(ResidenceCreationStateV2) valueSelector,
      required Function(bool) onToggle}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        BlocBuilder<ResidenceCreationCubitV2, ResidenceCreationStateV2>(
          buildWhen: (p, c) => valueSelector(p) != valueSelector(c),
          builder: (context, state) {
            final isYes = valueSelector(state);
            return Row(
              children: [
                _buildToggleButton("Oui", isYes, () => onToggle(true)),
                const Gap(8),
                _buildToggleButton("Non", !isYes, () => onToggle(false)),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
