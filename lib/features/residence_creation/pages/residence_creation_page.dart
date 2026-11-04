import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/home_v2/home_page_v2.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_cubit.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_state.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_step_key.dart';
import 'package:immoplus_pro/features/residence_creation/models/residence_recap.dart';
import 'package:immoplus_pro/features/residence_creation/pages/residence_creation_success_view.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/layout/creation_bottom_bar.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/layout/creation_header.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/layout/step_intro.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/step/step_content.dart';
import 'package:immoplus_pro/features/residence_detail/residence_details_page_v2.dart';

/// Création d'une résidence : les étapes et les champs viennent de
/// `GET /properties/creation-flow`.
class ResidenceCreationPage extends StatelessWidget {
  /// [residenceId] : ouvre le même formulaire pour modifier cette résidence.
  const ResidenceCreationPage({super.key, this.residenceId});

  final String? residenceId;

  static const String name = 'RESIDENCE_CREATION_PAGE';
  static const String routePath = '/create_residence';
  static const String editName = 'RESIDENCE_EDIT_PAGE';
  static const String editRoutePath = '/edit_residence/:id';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResidenceCreationCubit(residenceId: residenceId)..load(),
      child: const _ResidenceCreationView(),
    );
  }
}

class _ResidenceCreationView extends StatelessWidget {
  const _ResidenceCreationView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResidenceCreationCubit, ResidenceCreationState>(
      listenWhen: (previous, current) => !previous.updated && current.updated,
      listener: (context, state) {
        EasyLoadingHandler.showSuccessToast(
            text: 'Résidence modifiée avec succès');
        context.pop(true);
      },
      builder: (context, state) {
        final created = state.created;
        if (created != null) {
          return ResidenceCreationSuccessView(
            recap: ResidenceRecap.fromValues(state.values),
            onEdit: () => context.pushReplacementNamed(
              ResidenceDetailsPageV2.name,
              pathParameters: {'id': created.id},
            ),
            onHome: () => context.go(HomePageV2.routePath),
          );
        }

        return switch (state.loadStatus) {
          FlowLoadStatus.loading => Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()),
            ),
          FlowLoadStatus.failed => _LoadFailedView(
              onRetry: () => context.read<ResidenceCreationCubit>().load(),
            ),
          FlowLoadStatus.ready => _FormView(state: state),
        };
      },
    );
  }
}

class _FormView extends StatelessWidget {
  const _FormView({required this.state});

  final ResidenceCreationState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResidenceCreationCubit>();
    final flow = state.flow!;
    final isEditing = cubit.isEditing;
    final step = state.currentStep!;
    final stepKey = CreationStepKey.fromValue(step.key);

    void goBack() => state.stepIndex == 0 ? context.pop() : cubit.previous();

    return PopScope(
      canPop: state.stepIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) cubit.previous();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: CreationStyle.pagePadding,
                child: CreationHeader(
                  title: isEditing ? 'Modifier la résidence' : flow.title,
                  currentStep: state.stepIndex,
                  totalSteps: flow.steps.length,
                  onBack: goBack,
                ),
              ),
              Expanded(
                child: ListView(
                  key: ValueKey(step.key),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: CreationStyle.pagePadding
                      .copyWith(top: AppSpacing.md, bottom: AppSpacing.xl),
                  children: [
                    StepIntro(
                      stepNumber: state.stepIndex + 1,
                      stepLabel: stepKey == CreationStepKey.unknown
                          ? step.title
                          : stepKey.shortLabel,
                      title: step.title,
                      subtitle: step.subtitle,
                    ),
                    AppSpacing.gap24,
                    if (state.generalErrors.isNotEmpty)
                      _ErrorBanner(messages: state.generalErrors),
                    StepContent(step: step, state: state, cubit: cubit),
                  ],
                ),
              ),
              CreationBottomBar(
                isFirstStep: state.stepIndex == 0,
                isLastStep: state.isLastStep,
                isSubmitting: state.isSubmitting,
                onPrevious: cubit.previous,
                onNext: cubit.next,
                lastStepLabel: isEditing ? 'Enregistrer' : 'Créer ma résidence',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.messages});

  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: AppSpacing.edgeAll12,
      decoration: BoxDecoration(
        color: AppColors.red50,
        borderRadius: BorderRadius.circular(AppRadii.r12),
        border: Border.all(color: AppColors.red100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final message in messages)
            Text(message,
                style:
                    AppTypography.bodySmall.copyWith(color: AppColors.red600)),
        ],
      ),
    );
  }
}

class _LoadFailedView extends StatelessWidget {
  const _LoadFailedView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: AppSpacing.edgeAll24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Impossible de charger le formulaire.',
                  textAlign: TextAlign.center, style: AppTypography.bodyLarge),
              AppSpacing.gap16,
              ElevatedButton(
                  onPressed: onRetry, child: const Text('Réessayer')),
            ],
          ),
        ),
      ),
    );
  }
}
