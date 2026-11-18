import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/common/widgets/empty_state_v2.dart';
import 'package:immoplus_pro/core/error/error_context.dart';
import 'package:immoplus_pro/core/error/error_feedback.dart';
import 'package:immoplus_pro/core/models/query_filter.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/features/boost/pages/share_residence_page.dart';
import 'package:immoplus_pro/features/boost/repositories/boost_repository.dart';
import 'package:immoplus_pro/features/boost/widgets/boost_residence_card.dart';
import 'package:immoplus_pro/features/residence/residences_page_v2.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Page listant verticalement les résidences validées du propriétaire pour les partager (Boost).
class BoostResidencesPage extends StatefulWidget {
  const BoostResidencesPage({super.key});

  static const String name = 'BOOST_RESIDENCES_PAGE';
  static const String routePath = '/boost_residences';

  @override
  State<BoostResidencesPage> createState() => _BoostResidencesPageState();
}

class _BoostResidencesPageState extends State<BoostResidencesPage> {
  final PagingController<int, ResidenceModel> _pagingController =
      PagingController(firstPageKey: 1);

  String? _loadingResidenceId;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final filters = [
        QueryFilter(
          field: 'statusValidation',
          operator: FilterOperator.eq,
          value: ResidenceFilter.valide.value,
        ),
      ];

      final result = await LogmentRepository.getResidences(
        page: pageKey,
        orderBy: 'createdAt',
        orderDir: OrderDir.desc.value,
        where: QueryBuilder.build(filters: filters),
      );

      if (!mounted) return;

      final items = result.data ?? [];
      final isLastPage = result.hasNext == false;
      if (isLastPage) {
        _pagingController.appendLastPage(items);
      } else {
        _pagingController.appendPage(items, pageKey + 1);
      }
    } catch (error) {
      if (!mounted) return;
      ErrorFeedback.show(error, context: ErrorContext.feedLoad);
      _pagingController.error = error;
    }
  }

  Future<void> _onShareTap(ResidenceModel residence) async {
    if (_loadingResidenceId != null) return;

    setState(() => _loadingResidenceId = residence.id);
    try {
      final shareLink = await BoostRepository.generateOrGetShareLink(
        residenceId: residence.id,
      );
      if (!mounted) return;

      await context.pushNamed(
        ShareResidencePage.name,
        extra: ShareResidencePageArgs(
          residence: residence,
          shareLink: shareLink,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ErrorFeedback.show(error, context: ErrorContext.generic);
    } finally {
      if (mounted) {
        setState(() => _loadingResidenceId = null);
      }
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  _CircularBackButton(onTap: () => context.pop()),
                  const Gap(12),
                  Expanded(
                    child: Text(
                      'Booster une résidence',
                      style: AppTypography.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray950,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Text(
                'Sélectionnez une résidence validée et partagez son lien pour augmenter sa visibilité et vos réservations.',
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 13.5,
                  color: AppColors.gray500,
                  height: 1.4,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => Future.sync(() => _pagingController.refresh()),
                child: PagedListView<int, ResidenceModel>.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  pagingController: _pagingController,
                  separatorBuilder: (_, __) => const Gap(12),
                  builderDelegate: PagedChildBuilderDelegate<ResidenceModel>(
                    itemBuilder: (context, item, index) => BoostResidenceCard(
                      residence: item,
                      isLoading: _loadingResidenceId == item.id,
                      isDisabled: _loadingResidenceId != null &&
                          _loadingResidenceId != item.id,
                      onShare: () => _onShareTap(item),
                    ),
                    firstPageProgressIndicatorBuilder: (_) => const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: CupertinoActivityIndicator()),
                    ),
                    newPageProgressIndicatorBuilder: (_) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CupertinoActivityIndicator()),
                    ),
                    noItemsFoundIndicatorBuilder: (_) => const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: EmptyStateV2(
                        title: 'Aucune résidence validée',
                        description:
                            'Vos résidences validées apparaîtront ici dès qu’elles seront prêtes à être partagées.',
                        icon: Iconsax.home_2,
                      ),
                    ),
                    firstPageErrorIndicatorBuilder: (_) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Impossible de charger vos résidences validées.',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMedium
                                  .copyWith(color: AppColors.gray500),
                            ),
                            const Gap(12),
                            ElevatedButton(
                              onPressed: () => _pagingController.refresh(),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: const StadiumBorder(),
                              ),
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularBackButton extends StatelessWidget {
  const _CircularBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.rFull),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.gray200),
        ),
        child: const Icon(
          Icons.chevron_left_rounded,
          size: 24,
          color: AppColors.gray950,
        ),
      ),
    );
  }
}
