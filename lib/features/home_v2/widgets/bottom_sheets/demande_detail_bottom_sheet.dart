import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/cubits/demandes/demande_proposal_cubit.dart';
import 'package:immoplus_pro/cubits/demandes/demande_proposal_state.dart';
import 'package:immoplus_pro/data/models/demandes/alert_marketplace_model.dart';
import 'package:immoplus_pro/data/repositories/alerts_repository.dart';
import 'package:immoplus_pro/features/home_v2/widgets/bottom_sheets/demande_step1_overview.dart';
import 'package:immoplus_pro/features/home_v2/widgets/bottom_sheets/demande_step2_choose_property.dart';
import 'package:immoplus_pro/features/home_v2/widgets/bottom_sheets/demande_step3_success.dart';

class DemandeDetailBottomSheet extends StatefulWidget {
  final AlertMarketplaceItem item;

  const DemandeDetailBottomSheet({
    super.key,
    required this.item,
  });

  static Future<void> show(BuildContext context, AlertMarketplaceItem item) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) => DemandeDetailBottomSheet(item: item),
    );
  }

  @override
  State<DemandeDetailBottomSheet> createState() =>
      _DemandeDetailBottomSheetState();
}

class _DemandeDetailBottomSheetState extends State<DemandeDetailBottomSheet> {
  int _currentStep = 1;
  AlertProMatchItem? _proposedProperty;
  late final DemandeProposalCubit _proposalCubit;

  @override
  void initState() {
    super.initState();
    _proposalCubit = DemandeProposalCubit(alertId: widget.item.id)
      ..loadMatches();
    // Marquer automatiquement la demande comme consultée lors de l'ouverture
    AlertsRepository.markAsViewed(alertId: widget.item.id);
  }

  @override
  void dispose() {
    _proposalCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.90;

    return BlocProvider.value(
      value: _proposalCubit,
      child: BlocListener<DemandeProposalCubit, DemandeProposalState>(
        listener: (context, state) {
          if (state is DemandeProposalSuccess) {
            setState(() {
              _proposedProperty = state.proposedProperty;
              _currentStep = 3;
            });
          }
        },
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(12),
                // Barre de drag
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Gap(8),

                // Contenu dynamique selon l'étape
                Flexible(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: _buildStepContent(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return DemandeStep1Overview(
          key: const ValueKey(1),
          item: widget.item,
          onSeeCompatibleProperties: () {
            setState(() => _currentStep = 2);
          },
        );
      case 2:
        return DemandeStep2ChooseProperty(
          key: const ValueKey(2),
          item: widget.item,
          onBack: () {
            setState(() => _currentStep = 1);
          },
        );
      case 3:
        if (_proposedProperty == null) return const SizedBox();
        return DemandeStep3Success(
          key: const ValueKey(3),
          proposedItem: _proposedProperty!,
          onGoHome: () {
            Navigator.of(context).pop();
          },
        );
      default:
        return const SizedBox();
    }
  }
}
