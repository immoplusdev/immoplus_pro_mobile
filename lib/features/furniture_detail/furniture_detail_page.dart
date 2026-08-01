import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_model.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_status.dart';
import 'package:immoplus_pro/features/create_furniture/create_furniture_page.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_manager.dart';
import 'package:immoplus_pro/features/furniture_detail/cubit/furniture_cubit.dart';
import 'package:immoplus_pro/features/furniture_detail/cubit/furniture_state.dart';
import 'package:immoplus_pro/features/furniture_detail/widgets/furniture_detail_bottom_bar.dart';
import 'package:immoplus_pro/features/furniture_detail/widgets/furniture_metadata_chips.dart';
import 'package:immoplus_pro/features/furnitures/theme/furniture_theme.dart';
import 'package:immoplus_pro/features/shared_widgets/section_card.dart';
import 'package:immoplus_pro/features/shared_widgets/sliver_image_carousel_app_bar.dart';
import 'package:immoplus_pro/features/shared_widgets/mini_map_with_marker.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

/// Page de détail d'un meuble.
///
/// Utilise [FurnitureCubit] pour charger et gérer l'état du meuble.
class FurnitureDetailPage extends StatefulWidget {
  const FurnitureDetailPage({super.key, required this.furnitureId});

  final String furnitureId;

  static String name = 'furniture_detail_page';

  @override
  State<FurnitureDetailPage> createState() => _FurnitureDetailPageState();
}

class _FurnitureDetailPageState extends State<FurnitureDetailPage> {
  bool _isUpdatingStatus = false;

  @override
  void initState() {
    super.initState();
    context.read<FurnitureCubit>().getFurniture(widget.furnitureId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FurnitureCubit, FurnitureState>(
      listener: (context, state) {
        state.whenOrNull(
          deleted: (message) {
            ToastUtils.showSuccess(title: message);
            context.pop(true);
          },
          error: (message) {
            if (_isUpdatingStatus && mounted) {
              setState(() => _isUpdatingStatus = false);
            }
            ToastUtils.showError(title: message);
          },
          loaded: (furniture) {
            if (_isUpdatingStatus && mounted) {
              setState(() => _isUpdatingStatus = false);
              final isNowInactive =
                  furniture.status == FurnitureStatus.inactive;
              ToastUtils.showSuccess(
                title: isNowInactive
                    ? 'Meuble marqué comme indisponible'
                    : 'Meuble marqué comme actif',
              );
            }
          },
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => _buildLoadingScaffold(),
          loading: () => _buildLoadingScaffold(),
          loaded: (furniture) => _buildContent(furniture),
          deleted: (_) => const Scaffold(
            body: Center(child: CupertinoActivityIndicator()),
          ),
          error: (message) => _buildErrorScaffold(message),
        );
      },
    );
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 300,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  5,
                  (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
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

  Widget _buildErrorScaffold(String message) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        title: const Text('Détail du meuble'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(FontAwesomeIcons.triangleExclamation,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const Gap(16),
              Text(
                'Impossible de charger le meuble',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                message,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(24),
              ElevatedButton.icon(
                style: FurnitureTheme.primaryButtonStyle.copyWith(
                  minimumSize: WidgetStateProperty.all(const Size(200, 44)),
                ),
                onPressed: () {
                  context
                      .read<FurnitureCubit>()
                      .getFurniture(widget.furnitureId);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(FurnitureModel furniture) {
    final images = furniture.images ?? [];
    final imageUrls = images.map((id) => Utils.getImagePath(id: id)).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.whiteBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverImageCarouselAppBar(
            imageUrls: imageUrls,
            backIconColor: AppColors.primary,
            emptyPlaceholder: Container(
              color: Colors.grey.shade200,
              child: Center(
                child: FaIcon(FontAwesomeIcons.couch,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              context.read<FurnitureCubit>().getFurniture(widget.furnitureId);
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FurnitureTheme.statusBadge(furniture.status.name),
                  const Gap(8),
                  Text(
                    furniture.titre,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      const Gap(4),
                      Flexible(
                        child: Text(
                          furniture.adresse,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    '${Utils.formatCurrency(furniture.prix)} FCFA',
                    style: FurnitureTheme.priceText.copyWith(fontSize: 22),
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.eye,
                        size: 13,
                        color: Colors.grey.shade400,
                      ),
                      const Gap(4),
                      Text(
                        '${furniture.viewsCount} vue${furniture.viewsCount > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SectionDivider()),
          SliverToBoxAdapter(
            child: SectionCard(
              title: 'Description',
              icon: FontAwesomeIcons.alignLeft.data,
              iconColor: AppColors.primary,
              child: Text(
                furniture.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SectionDivider()),
          SliverToBoxAdapter(
            child: SectionCard(
              title: 'Localisation',
              icon: FontAwesomeIcons.locationDot.data,
              iconColor: AppColors.primary,
              child: Text(
                furniture.adresse,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          if (furniture.lat != null && furniture.lng != null)
            SliverToBoxAdapter(
              child: MiniMapWithMarker(
                lat: furniture.lat!,
                lng: furniture.lng!,
                title: furniture.titre,
                markerColor: AppColors.primary,
              ),
            ),
          if (_hasDetails(furniture)) ...[
            const SliverToBoxAdapter(child: SectionDivider()),
            SliverToBoxAdapter(
              child: SectionCard(
                title: 'Détails',
                icon: FontAwesomeIcons.sliders.data,
                iconColor: AppColors.primary,
                child: FurnitureMetadataChips(furniture: furniture),
              ),
            ),
          ],
          if (furniture.video != null && furniture.video!.isNotEmpty) ...[
            const SliverToBoxAdapter(child: SectionDivider()),
            SliverToBoxAdapter(
              child: SectionCard(
                title: 'Vidéo',
                icon: FontAwesomeIcons.video.data,
                iconColor: AppColors.primary,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.furnitureVioletLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.circlePlay,
                        color: AppColors.primary,
                      ),
                      const Gap(10),
                      Text(
                        'Vidéo disponible',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SliverGap(100),
        ],
      ),
      bottomNavigationBar: FurnitureDetailBottomBar(
        furniture: furniture,
        isUpdatingStatus: _isUpdatingStatus,
        onEdit: () => _onEdit(furniture),
        onDelete: () => _onDelete(furniture),
        onToggleAvailability: () => _onToggleAvailability(furniture),
      ),
    );
  }

  bool _hasDetails(FurnitureModel furniture) {
    return (furniture.category?.isNotEmpty ?? false) ||
        (furniture.type?.isNotEmpty ?? false) ||
        (furniture.etat?.isNotEmpty ?? false) ||
        (furniture.metadata?.isNotEmpty ?? false);
  }

  void _onEdit(FurnitureModel furniture) {
    FurnitureCreationManager().fromModel(furniture);
    context.pushNamed(CreateFurniturePage.name).then((result) {
      if (result == true && mounted) {
        FurnitureCreationManager().reset();
        context.read<FurnitureCubit>().getFurniture(widget.furnitureId);
      }
    });
  }

  Future<void> _onDelete(FurnitureModel furniture) async {
    final confirm = await AppDialog.confirmDialog(
      context: context,
      content:
          'Êtes-vous sûr de vouloir supprimer ce meuble ? Cette action est irréversible.',
    );
    if (confirm == true && mounted) {
      context.read<FurnitureCubit>().deleteFurniture(furniture.id);
    }
  }

  void _onToggleAvailability(FurnitureModel furniture) {
    setState(() => _isUpdatingStatus = true);
    final newStatus = furniture.status == FurnitureStatus.inactive
        ? FurnitureStatus.active
        : FurnitureStatus.inactive;
    context.read<FurnitureCubit>().updateFurniture(
      furniture.id,
      {'status': newStatus.name},
    );
  }
}
