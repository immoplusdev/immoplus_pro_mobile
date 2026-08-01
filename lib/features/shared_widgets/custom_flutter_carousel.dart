import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/features/shared_widgets/image_counter_badge.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class CustomFlutterCarousel extends StatefulWidget {
  final List<String> images;
  final double? height;
  final double aspectRatio;
  final Function(int index)? onImageTap;
  final bool showGradient;
  final bool showIndicator;
  final bool showCounter;
  final double viewportFraction;
  final bool enableInfiniteScroll;
  final bool autoPlay;

  const CustomFlutterCarousel({
    super.key,
    required this.images,
    this.height,
    this.aspectRatio = 1.70,
    this.onImageTap,
    this.showGradient = false,
    this.showIndicator = false,
    this.showCounter = true,
    this.viewportFraction = 1.0,
    this.enableInfiniteScroll = true,
    this.autoPlay = false,
  });

  @override
  State<CustomFlutterCarousel> createState() => _CustomFlutterCarouselState();
}

class _CustomFlutterCarouselState extends State<CustomFlutterCarousel> {
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);
  final Set<String> _preloaded = {};
  int _lastPreloadedIndex = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_lastPreloadedIndex == -1) {
      _preloadBatch(0);
    }
  }

  @override
  void didUpdateWidget(CustomFlutterCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.images, oldWidget.images)) {
      _preloaded.clear();
      _lastPreloadedIndex = -1;
      _preloadBatch(0);
    }
  }

  String _getUrl(String idOrUrl) {
    if (idOrUrl.startsWith('http')) return idOrUrl;
    return Utils.getImagePath(id: idOrUrl);
  }

  void _preloadBatch(int start) {
    if (widget.images.isEmpty) return;
    final end = (start + 5).clamp(0, widget.images.length);
    for (int i = start; i < end; i++) {
      final url = _getUrl(widget.images[i]);
      if (!_preloaded.contains(url)) {
        precacheImage(
          CachedNetworkImageProvider(url),
          context,
        ).then((_) {
          if (mounted) {
            setState(() => _preloaded.add(url));
          }
        }).catchError((e) {
          debugPrint('Error preloading image: $url - $e');
        });
      }
    }
    _lastPreloadedIndex = end - 1;
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: widget.height,
        color: Colors.grey.shade200,
        child: _buildErrorWidget(),
      );
    }

    return Stack(
      children: [
        FlutterCarousel.builder(
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            final imageId = widget.images[index];
            final url = _getUrl(imageId);
            final isCached = _preloaded.contains(url);

            Widget imageWidget = Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey.shade100,
              child: isCached
                  ? Image(
                      image: CachedNetworkImageProvider(url),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildErrorWidget(),
                    )
                  : CachedNetworkImage(
                      imageUrl: url,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholder: (context, url) => _buildPlaceholder(),
                      errorWidget: (context, url, error) => _buildErrorWidget(),
                      fit: BoxFit.cover,
                    ),
            );

            if (widget.showGradient) {
              imageWidget = Container(
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
                child: imageWidget,
              );
            }

            // Wrapping with Hero for smooth transitions if an ID is available
            imageWidget = Hero(
              tag: imageId,
              child: imageWidget,
            );

            if (widget.onImageTap != null) {
              return GestureDetector(
                onTap: () => widget.onImageTap!(index),
                child: imageWidget,
              );
            }

            return imageWidget;
          },
          options: FlutterCarouselOptions(
            height: widget.height,
            aspectRatio: widget.height != null ? null : widget.aspectRatio,
            viewportFraction: widget.viewportFraction,
            initialPage: 0,
            enableInfiniteScroll:
                widget.enableInfiniteScroll && widget.images.length > 1,
            reverse: false,
            autoPlay: widget.autoPlay,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            showIndicator: widget.showIndicator,
            indicatorMargin: 20,
            slideIndicator: CircularSlideIndicator(
              slideIndicatorOptions: const SlideIndicatorOptions(
                indicatorRadius: 4,
                enableHalo: true,
                enableAnimation: true,
                itemSpacing: 12,
              ),
            ),
            onPageChanged: (index, _) {
              _currentIndex.value = index;
              if (index >= _lastPreloadedIndex - 1 &&
                  _lastPreloadedIndex < widget.images.length - 1) {
                _preloadBatch(_lastPreloadedIndex + 1);
              }
            },
          ),
        ),
        if (widget.showCounter && widget.images.length > 1)
          Positioned(
            bottom: 15,
            right: 15,
            child: ValueListenableBuilder<int>(
              valueListenable: _currentIndex,
              builder: (context, index, _) => ImageCounterBadge(
                current: (index % widget.images.length) + 1,
                total: widget.images.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(color: Colors.white),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: FaIcon(FontAwesomeIcons.images,
          size: 40,
          color: Colors.grey,
        ),
      ),
    );
  }
}
