import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_model.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_status.dart';
import 'package:immoplus_pro/features/create_furniture/create_furniture_page.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_manager.dart';
import 'package:immoplus_pro/features/furniture_detail/cubit/furniture_cubit.dart';
import 'package:immoplus_pro/features/furniture_detail/cubit/furniture_state.dart';
import 'package:immoplus_pro/features/furnitures/theme/furniture_theme.dart';
import 'package:immoplus_pro/features/home_page/utils/custom_popup.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:map_launcher/map_launcher.dart' as mpl;
import 'package:shimmer/shimmer.dart';

/// Page de détail d'un meuble.

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
            CustomPopup.showSuccesToast(text: message);
            context.pop(true);
          },
          error: (message) {
            if (_isUpdatingStatus && mounted) {
              setState(() => _isUpdatingStatus = false);
            }
            CustomPopup.showErrorToast(text: message);
          },
          loaded: (furniture) {
            if (_isUpdatingStatus && mounted) {
              setState(() => _isUpdatingStatus = false);
              final isNowInactive =
                  furniture.status == FurnitureStatus.inactive;
              CustomPopup.showSuccesToast(
                text: isNowInactive
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

  // ────────────────────────────────────────────────
  // LOADING
  // ────────────────────────────────────────────────

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
            // Image skeleton
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
            // Text skeletons
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

  // ────────────────────────────────────────────────
  // ERROR
  // ────────────────────────────────────────────────

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
              Icon(
                FontAwesomeIcons.triangleExclamation,
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

  // ────────────────────────────────────────────────
  // CONTENT
  // ────────────────────────────────────────────────

  Widget _buildContent(FurnitureModel furniture) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.whiteBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // ── SliverAppBar avec carousel ──
          _FurnitureAppBar(furniture: furniture),

          // ── Pull-to-refresh ──
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              context.read<FurnitureCubit>().getFurniture(widget.furnitureId);
            },
          ),

          // ── Titre + Prix + Statut ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge statut
                  FurnitureTheme.statusBadge(furniture.status.name),
                  const Gap(8),
                  // Titre
                  Text(
                    furniture.titre,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Gap(4),
                  // Adresse
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
                  // Prix
                  Text(
                    '${Utils.formatCurrency(furniture.prix)} FCFA',
                    style: FurnitureTheme.priceText.copyWith(fontSize: 22),
                  ),
                  const Gap(4),
                  // Vues
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.eye,
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

          // ── Séparateur ──
          const SliverToBoxAdapter(child: _SectionDivider()),

          // ── Description ──
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'Description',
              icon: FontAwesomeIcons.alignLeft,
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

          // ── Localisation ──
          const SliverToBoxAdapter(child: _SectionDivider()),
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'Localisation',
              icon: FontAwesomeIcons.locationDot,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    furniture.adresse,
                    style: const TextStyle(fontSize: 14),
                  ),
                  // if (furniture.ville != null || furniture.commune != null)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 4),
                  //     child: Text(
                  //       [furniture.commune, furniture.ville]
                  //           .where((e) => e != null && e.isNotEmpty)
                  //           .join(', '),
                  //       style: TextStyle(
                  //         fontSize: 13,
                  //         color: Colors.grey.shade600,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),

          // ── Mini Map ──
          if (furniture.lat != null && furniture.lng != null)
            SliverToBoxAdapter(
              child: _FurnitureMiniMap(furniture: furniture),
            ),

          // ── Métadonnées ──
          if (_hasDetails(furniture)) ...[
            const SliverToBoxAdapter(child: _SectionDivider()),
            SliverToBoxAdapter(
              child: _SectionCard(
                title: 'Détails',
                icon: FontAwesomeIcons.sliders,
                child: _buildMetadataChips(furniture),
              ),
            ),
          ],

          // ── Vidéo ──
          if (furniture.video != null && furniture.video!.isNotEmpty) ...[
            const SliverToBoxAdapter(child: _SectionDivider()),
            SliverToBoxAdapter(
              child: _SectionCard(
                title: 'Vidéo',
                icon: FontAwesomeIcons.video,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.furnitureVioletLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.circlePlay,
                        color: AppColors.furnitureViolet,
                      ),
                      const Gap(10),
                      Text(
                        'Vidéo disponible',
                        style: TextStyle(
                          color: AppColors.furnitureViolet,
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

      // ── Bottom Bar : Supprimer / Badge état + Bouton action / Modifier ──
      bottomNavigationBar: _FurnitureBottomBar(
        furniture: furniture,
        isUpdatingStatus: _isUpdatingStatus,
        onEdit: () => _onEdit(furniture),
        onDelete: () => _onDelete(furniture),
        onToggleAvailability: () => _onToggleAvailability(furniture),
      ),
    );
  }

  // ────────────────────────────────────────────────
  // METADATA CHIPS
  // ────────────────────────────────────────────────

  bool _hasDetails(FurnitureModel furniture) {
    return (furniture.category?.isNotEmpty ?? false) ||
        (furniture.type?.isNotEmpty ?? false) ||
        (furniture.etat?.isNotEmpty ?? false) ||
        (furniture.metadata?.isNotEmpty ?? false);
  }

  /// Parse une couleur API (hex) en [Color]. Gère 6 ou 8 caractères (préfixe FF si 6).
  Color? _parseApiColor(String rawColor) {
    var hex = rawColor.trim().toUpperCase().replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    if (hex.length != 8) {
      return null;
    }
    final value = int.tryParse(hex, radix: 16);
    if (value == null) {
      return null;
    }
    return Color(value);
  }

  /// Liste des couleurs affichables à partir de [furniture.metadata?.colors].
  List<Color> _resolveAvailableColors(FurnitureModel furniture) {
    final raw = furniture.metadata?['colors'];
    if (raw == null) return const <Color>[];
    if (raw is! List) return const <Color>[];
    return raw
        .map((e) => _parseApiColor(e.toString()))
        .whereType<Color>()
        .toList();
  }

  Widget _buildMetadataChips(FurnitureModel furniture) {
    final metadata = Map<String, dynamic>.from(furniture.metadata ?? {});
    metadata.remove('etat');
    metadata.remove('type');
    metadata.remove('category');

    final items = <MapEntry<String, dynamic>>[
      if (furniture.category?.isNotEmpty ?? false)
        MapEntry('Catégorie', furniture.category),
      if (furniture.type?.isNotEmpty ?? false) MapEntry('Type', furniture.type),
      if (furniture.etat?.isNotEmpty ?? false) MapEntry('État', furniture.etat),
      ...metadata.entries,
    ].where((e) => e.value != null && e.value.toString().isNotEmpty).toList();

    if (items.isEmpty) return const SizedBox.shrink();
    final maxChipWidth = MediaQuery.sizeOf(context).width - 64;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((entry) {
        // Couleurs : pastilles superposées au lieu du texte
        final isColorsKey = entry.key == 'colors' || entry.key == 'Couleurs';
        final availableColors = isColorsKey ? _resolveAvailableColors(furniture) : <Color>[];

        if (isColorsKey && availableColors.isNotEmpty) {
          return Container(
            constraints: BoxConstraints(maxWidth: maxChipWidth),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.furnitureVioletLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.furnitureViolet.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Couleurs : ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: availableColors.asMap().entries.map((e) {
                    final index = e.key;
                    final color = e.value;
                    return Transform.translate(
                      offset: Offset(index * -8, 0),
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }

        if (isColorsKey && availableColors.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          constraints: BoxConstraints(maxWidth: maxChipWidth),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.furnitureVioletLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.furnitureViolet.withValues(alpha: 0.2),
            ),
          ),
          child: RichText(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${entry.key} : ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                TextSpan(
                  text: _formatMetadataValue(entry.key, entry.value),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.furnitureViolet,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatMetadataValue(String key, dynamic value) {
    if (key == 'Type' || key == 'type') {
      final type = value.toString();
      return type
          .split('-')
          .where((s) => s.isNotEmpty)
          .map((s) => s[0].toUpperCase() + s.substring(1))
          .join(' ');
    }
    if (key == 'Catégorie' || key == 'category') {
      switch (value.toString()) {
        case 'mobilier-interieur':
          return 'Mobilier intérieur';
        case 'mobilier-exterieur':
          return 'Mobilier extérieur';
        default:
          return value.toString();
      }
    }
    if (value is List) {
      return value.join(', ');
    }
    return value.toString();
  }

  // ────────────────────────────────────────────────
  // ACTIONS
  // ────────────────────────────────────────────────

  /// Ouvre CreateFurniturePage en mode édition.
  void _onEdit(FurnitureModel furniture) {
    FurnitureCreationManager().fromModel(furniture);
    context.pushNamed(CreateFurniturePage.name).then((result) {
      if (result == true && mounted) {
        FurnitureCreationManager().reset();
        context.read<FurnitureCubit>().getFurniture(widget.furnitureId);
      }
    });
  }

  /// Confirmation + suppression du meuble.
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

  /// Bascule la disponibilité : Actif → Indisponible, Indisponible → Actif (PATCH status).
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

// ════════════════════════════════════════════════════════════════════
// SLIVER APP BAR (Carousel d'images)
// ════════════════════════════════════════════════════════════════════

class _FurnitureAppBar extends StatelessWidget {
  const _FurnitureAppBar({required this.furniture});

  final FurnitureModel furniture;

  @override
  Widget build(BuildContext context) {
    final images = furniture.images ?? [];

    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      expandedHeight: 300,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 20,
          onPressed: () => context.pop(),
          style: IconButton.styleFrom(
            fixedSize: const Size(18, 18),
            padding: EdgeInsets.zero,
          ),
          icon: Container(
            width: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.chevron_back,
                color: AppColors.furnitureViolet,
              ),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: images.isNotEmpty
            ? FlutterCarousel(
                items: images
                    .map<Widget>(
                      (imageId) => Container(
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade700,
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0, 0.4],
                          ),
                        ),
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: Utils.getImagePath(id: imageId),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            period: const Duration(milliseconds: 500),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    )
                    .toList(),
                options: FlutterCarouselOptions(
                  height: 500,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: images.length > 1,
                  autoPlay: false,
                  showIndicator: images.length > 1,
                  indicatorMargin: 20,
                  slideIndicator: CircularSlideIndicator(),
                  floatingIndicator: true,
                ),
              )
            : Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.couch,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// MINI MAP
// ════════════════════════════════════════════════════════════════════

class _FurnitureMiniMap extends StatefulWidget {
  const _FurnitureMiniMap({required this.furniture});

  final FurnitureModel furniture;

  @override
  State<_FurnitureMiniMap> createState() => _FurnitureMiniMapState();
}

class _FurnitureMiniMapState extends State<_FurnitureMiniMap> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addMarker();
  }

  Future<void> _addMarker() async {
    final lat = widget.furniture.lat!;
    final lng = widget.furniture.lng!;

    final customMarker = await GoogleMapsCustomMarker.createCustomMarker(
      marker: Marker(
        markerId: const MarkerId('furnitureMarker'),
        position: LatLng(lat, lng),
        onTap: () async {
          if (await mpl.MapLauncher.isMapAvailable(mpl.MapType.google) ??
              false) {
            mpl.MapLauncher.showDirections(
              destinationTitle: widget.furniture.titre,
              destination: mpl.Coords(lat, lng),
              directionsMode: mpl.DirectionsMode.driving,
              mapType: mpl.MapType.google,
            );
          } else {
            final availableMaps = await mpl.MapLauncher.installedMaps;
            await availableMaps.first.showDirections(
              destinationTitle: widget.furniture.titre,
              destination: mpl.Coords(lat, lng),
              directionsMode: mpl.DirectionsMode.driving,
            );
          }
        },
      ),
      shape: MarkerShape.bubble,
      imagePixelRatio: 2,
      title: widget.furniture.titre,
      textSize: 35,
      backgroundColor: AppColors.furnitureViolet,
    );

    if (mounted) {
      setState(() {
        _markers.add(customMarker);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lat = widget.furniture.lat!;
    final lng = widget.furniture.lng!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 200,
          child: GoogleMap(
            mapType: MapType.normal,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, lng),
              zoom: 14,
            ),
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {},
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// BOTTOM BAR : Badge état (Actif / Indisponible) + Bouton action (Désactiver / Activer)
// ════════════════════════════════════════════════════════════════════

/// Vert = Actif (#22C55E), Orange = Indisponible (#F59E0B).
/// Le badge affiche l'état actuel, le bouton affiche l'action (Désactiver / Activer).
class _FurnitureBottomBar extends StatelessWidget {
  const _FurnitureBottomBar({
    required this.furniture,
    required this.isUpdatingStatus,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAvailability,
  });

  final FurnitureModel furniture;
  final bool isUpdatingStatus;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleAvailability;

  static const Color _green = Color(0xFF22C55E);
  static const Color _orange = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    final isInactive = furniture.status == FurnitureStatus.inactive;

    const double buttonHeight = 44;
    const double spacing = 12;
    const double horizontalPadding = 20;
    const double topPadding = 16;
    const double bottomPadding = 24;

    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        bottomPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // ── Bouton Supprimer ──
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  minimumSize: Size(0, buttonHeight),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: onDelete,
                child: const Icon(FontAwesomeIcons.trash, size: 16),
              ),
            ),

            Gap(spacing),

            // ── Bouton action (Désactiver / Activer) — largeur réduite pour laisser place à Modifier ──
            Expanded(
              flex: 1,
              child: isUpdatingStatus
                  ? Container(
                      height: buttonHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100,
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: buttonHeight,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isInactive ? _green : _orange,
                          side: BorderSide(
                            color: isInactive ? _green : _orange,
                          ),
                          minimumSize: Size(0, buttonHeight),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: onToggleAvailability,
                        child: Text(
                          isInactive ? 'Activer' : 'Désactiver',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
            ),

            Gap(spacing),

            // ── Bouton Modifier (plus d’espace) ──
            Expanded(
              flex: 1,
              child: SizedBox(
                height: buttonHeight,
                child: ElevatedButton.icon(
                  style: FurnitureTheme.primaryButtonStyle.copyWith(
                    minimumSize: WidgetStateProperty.all(Size(0, buttonHeight)),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: onEdit,
                  icon: const Icon(FontAwesomeIcons.penToSquare, size: 12),
                  label: const Text('Modifier', style: TextStyle(fontSize: 12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge affichant l'état actuel : Actif (vert ✔️) ou Indisponible (orange ⏸️).
// ignore: unused_element
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isInactive});

  final bool isInactive;

  static const Color _green = Color(0xFF22C55E);
  static const Color _orange = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    if (isInactive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _orange.withValues(alpha: 0.12),
          border: Border.all(color: _orange, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.pause, size: 12, color: _orange),
            const Gap(6),
            Text(
              'Indisponible',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _orange,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _green.withValues(alpha: 0.12),
        border: Border.all(color: _green, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.check, size: 12, color: _green),
          const Gap(6),
          Text(
            'Actif',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _green,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// SECTION CARD HELPER
// ════════════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: FurnitureTheme.sectionCardDecoration,
        padding: FurnitureTheme.sectionCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.furnitureViolet),
                const Gap(8),
                Text(
                  title,
                  style: FurnitureTheme.sectionTitle.copyWith(fontSize: 16),
                ),
              ],
            ),
            const Gap(12),
            child,
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// DIVIDER HELPER
// ════════════════════════════════════════════════════════════════════

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: Colors.grey.shade200,
        indent: 16,
        endIndent: 16,
      ),
    );
  }
}
