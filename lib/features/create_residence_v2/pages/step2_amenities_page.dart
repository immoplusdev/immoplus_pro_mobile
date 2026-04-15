import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/common/widgets/v2/amenities_grid_selector_v2.dart';
import 'package:immoplus_pro/features/create_residence_v2/logic/residence_creation_cubit_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/creation_navigation_buttons_v2.dart';

class Step2AmenitiesPage extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step2AmenitiesPage({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

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
                const Text(
                  "Que proposez vous dans votre bien ?",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const Gap(15),
                BlocBuilder<ResidenceCreationCubitV2, ResidenceCreationStateV2>(
                  buildWhen: (p, c) => p.commodites != c.commodites,
                  builder: (context, state) {
                    final cubit = context.read<ResidenceCreationCubitV2>();
                    return AmenitiesGridSelectorV2(
                      isSelected: cubit.hasCommodite,
                      onToggle: cubit.toggleCommodite,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<ResidenceCreationCubitV2, ResidenceCreationStateV2>(
          builder: (context, state) {
            final isValid = state.commodites.isNotEmpty;
            return CreationNavigationButtonsV2(
              onPrevious: onPrevious,
              onNext: isValid ? onNext : null,
            );
          },
        ),
      ],
    );
  }
}
