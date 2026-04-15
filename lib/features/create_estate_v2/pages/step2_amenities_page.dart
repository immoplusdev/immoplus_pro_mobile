import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/common/widgets/v2/amenities_grid_selector_v2.dart';
import 'package:immoplus_pro/features/create_estate_v2/logic/estate_creation_cubit_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/creation_navigation_buttons_v2.dart';

class Step2EstateAmenitiesPage extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step2EstateAmenitiesPage({
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
                BlocBuilder<EstateCreationCubitV2, EstateCreationStateV2>(
                  buildWhen: (p, c) => p.amentities != c.amentities,
                  builder: (context, state) {
                    final cubit = context.read<EstateCreationCubitV2>();
                    return AmenitiesGridSelectorV2(
                      isSelected: cubit.hasAmenity,
                      onToggle: cubit.toggleAmenity,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<EstateCreationCubitV2, EstateCreationStateV2>(
          builder: (context, state) {
            final isValid = state.amentities.isNotEmpty;
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
