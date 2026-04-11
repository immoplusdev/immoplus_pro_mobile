import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_estate_v2/enums/estate_payment_frequency.dart';
import 'package:immoplus_pro/features/create_estate_v2/logic/estate_creation_cubit_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/creation_navigation_buttons_v2.dart';

class Step4EstatePricePage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step4EstatePricePage({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step4EstatePricePage> createState() => _Step4EstatePricePageState();
}

class _Step4EstatePricePageState extends State<Step4EstatePricePage> {
  late TextEditingController _prixController;

  @override
  void initState() {
    super.initState();
    final currentPrix = context.read<EstateCreationCubitV2>().state.prix;
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
                const Text("Prix du bien :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(15),
                TextField(
                  controller: _prixController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final prix = int.tryParse(val) ?? 0;
                    context.read<EstateCreationCubitV2>().updatePrix(prix);
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
                const Gap(30),
                const Text("Fréquence de paiement / Type de vente :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(20),
                BlocBuilder<EstateCreationCubitV2, EstateCreationStateV2>(
                  buildWhen: (p, c) =>
                      p.typeLocation != c.typeLocation || p.aLouer != c.aLouer,
                  builder: (context, state) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: EstatePaymentFrequency.values.length,
                      itemBuilder: (context, index) {
                        final freq = EstatePaymentFrequency.values[index];
                        final isSelected = state.typeLocation == freq.value &&
                            (freq.value != 'vente' || !state.aLouer);

                        return _buildFrequencyCard(context, freq, isSelected);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<EstateCreationCubitV2, EstateCreationStateV2>(
          builder: (context, state) {
            final isValid = state.prix > 0 && state.typeLocation.isNotEmpty;

            return CreationNavigationButtonsV2(
              onPrevious: widget.onPrevious,
              onNext: isValid ? widget.onNext : null,
              nextText: state.id != null ? "Sauvegarder" : "Terminer",
            );
          },
        ),
      ],
    );
  }

  Widget _buildFrequencyCard(
      BuildContext context, EstatePaymentFrequency freq, bool isSelected) {
    return InkWell(
      onTap: () {
        context
            .read<EstateCreationCubitV2>()
            .updateFrequency(freq.value, freq.value != 'vente');
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F4FA) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              freq.icon,
              size: 30,
              color: isSelected ? AppColors.primary : Colors.grey.shade400,
            ),
            const Gap(10),
            Text(
              freq.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
