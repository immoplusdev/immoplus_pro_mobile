import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/features/create_estate_v2/create_estate_page_v2.dart';
import 'package:immoplus_pro/features/estate_detail/components/detail_rooms.dart';
import 'package:immoplus_pro/features/estate_detail/cubit/estate_cubit.dart';
import 'package:immoplus_pro/features/shared_widgets/detail_action_bottom_bar.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/features/residence_detail/components/inititial_detail_screen.dart';
import 'package:immoplus_pro/features/shared_widgets/loading_page.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/services/analytics_service.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'components/detail_logment_appbar.dart';
import 'components/detail_logment_infos.dart';

class EstateDetailsPageV2 extends StatefulWidget {
  const EstateDetailsPageV2({
    super.key,
    required this.idProduct,
  });

  final String idProduct;
  static const name = 'ESTATE_DETAILS_PAGE_V2';

  static String routePath() => '/estate_details_v2/:id';

  @override
  State<EstateDetailsPageV2> createState() => _EstateDetailsPageV2State();
}

class _EstateDetailsPageV2State extends State<EstateDetailsPageV2> {
  @override
  void initState() {
    _getEstateById();
    super.initState();
  }

  _getEstateById() {
    context.read<EstateCubit>().getEstate(id: widget.idProduct);
  }

  void _onEdit(BienImmobilierModel bien) {
    context.pushNamed(CreateEstatePageV2.name, extra: bien).then((result) {
      if (result == true && mounted) {
        _getEstateById();
      }
    });
  }

  Future<void> _onDelete(BienImmobilierModel bien) async {
    final result = await AppDialog.confirmDialog(
      context: context,
      content:
          'Êtes-vous sûr de vouloir supprimer ce bien immobilier ? Cette action est irréversible.',
    );
    if (result == true && mounted) {
      context.read<EstateCubit>().deleteEstate(id: bien.id);
    }
  }

  Future<void> _onToggleAvailability(BienImmobilierModel bien) async {
    final newStatus = !bien.bienImmobilierDisponible;
    getIt<AnalyticsService>().logPropertyAvailabilityToggled(
      idBien: bien.id,
      isAvailable: newStatus,
    );
    if (bien.bienImmobilierDisponible) {
      await AppDialog.confirm(
        context: context,
        content:
            'Les biens indisponibles ne seront pas accessibles aux clients pour effectuer des réservations.',
        rollback: () {
          context.read<EstateCubit>().updateEstate(
                id: bien.id,
                data: {'bienImmobilierDisponible': false},
              );
          context.pop();
        },
      );
    } else {
      context.read<EstateCubit>().updateEstate(
        id: bien.id,
        data: {'bienImmobilierDisponible': true},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EstateCubit, RequestState>(
      listener: (context, state) {
        if (state is REQUEST_SUCCESS) {
          ToastUtils.showSuccess(
              title: "Opération réussie", description: state.message);
          context.pop(true);
        }
      },
      builder: (context, state) {
        if (state is REQUEST_LOADING) {
          return const LoadingPage();
        }

        if (state is REQUEST_BIEN_IMMOBILIER_DATA) {
          final estate = state.data;
          return Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            body: CustomScrollView(
              slivers: <Widget>[
                // APP BAR (Carousel)
                DetailEstateAppBar(bienImmobilier: estate),

                // TITLE & PRICE
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                estate.nom,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const Gap(4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.grey, size: 16),
                                  const Gap(4),
                                  Expanded(
                                    child: Text(
                                      estate.adresse,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(10),
                        Text(
                          Utils.formatCurrency(estate.prix),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ROOMS / STATS
                DetailEstateRooms(bienImmobilier: estate),

                // INFOS (Already Slivers in some cases, but checks needed)
                const SliverToBoxAdapter(child: Gap(10)),
                DetailEstateInfos(bienImmobilier: estate),

                // DESCRIPTION
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "À propos de ce bien",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Gap(12),
                        MarkdownBody(
                          data: estate.description,
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const Gap(30),
                      ],
                    ),
                  ),
                ),

                // LOADER
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    _getEstateById();
                  },
                ),

                const SliverToBoxAdapter(child: Gap(100)),
              ],
            ),
            bottomNavigationBar: DetailActionBottomBar(
              isInactive: !estate.bienImmobilierDisponible,
              isUpdatingStatus: false,
              onEdit: () => _onEdit(estate),
              onDelete: () => _onDelete(estate),
              onToggleAvailability: () => _onToggleAvailability(estate),
              config: const DetailActionBottomBarConfig(
                editLabel: 'Modifier le bien',
              ),
            ),
          );
        }

        return InitialDetailLogmentScreen(
          idProduct: widget.idProduct,
        );
      },
    );
  }
}
