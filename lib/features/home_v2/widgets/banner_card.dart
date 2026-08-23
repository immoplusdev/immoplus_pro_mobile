import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:immoplus_pro/data/models/banners/banner_model.dart';
import 'package:immoplus_pro/features/home_v2/widgets/banner_item.dart';
import 'package:immoplus_pro/cubits/banners/banners_cubit.dart';
import 'package:immoplus_pro/cubits/banners/banners_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:gap/gap.dart';

class BannerCard extends StatefulWidget {
  final VoidCallback? onDismiss;

  const BannerCard({
    super.key,
    this.onDismiss,
  });

  @override
  State<BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {
  int _currentIndex = 0;
  bool _isDismissed = false;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannersCubit, BannersState>(
      builder: (context, state) {
        final apiBanners = state.maybeWhen(
          success: (banners) => banners,
          orElse: () => <BannerModel>[],
        );

        // Si pas de bannières ou si l'utilisateur a fermé, on affiche le secondChild ou le child par défaut
        if (apiBanners.isEmpty || _isDismissed) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOutQuart,
          switchOutCurve: Curves.easeInQuart,
          child: Padding(
            key: const ValueKey('banner_active'),
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              width: double.infinity,
              // height: 160,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: _getBackgroundColor(apiBanners),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: apiBanners.length,
                    options: CarouselOptions(
                      height: 88,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return BannerItem(
                        banner: apiBanners[index],
                        onCloseTap: () {
                          setState(() {
                            _isDismissed = true;
                          });
                          widget.onDismiss?.call();
                        },
                      );
                    },
                  ),
                  const Gap(4),
                  _buildDots(apiBanners.length),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(List<BannerModel> apiBanners) {
    if (_currentIndex >= 0 && _currentIndex < apiBanners.length) {
      final colorStr = apiBanners[_currentIndex].bgColor;
      if (colorStr != null && colorStr.isNotEmpty) {
        try {
          return Color(int.parse(colorStr.replaceAll('#', '0xFF')));
        } catch (_) {
          return AppColors.customBlue;
        }
      }
    }
    return AppColors.customBlue;
  }

  Widget _buildDots(int count) {
    if (count <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _currentIndex == index ? 20 : 8,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(_currentIndex == index ? 1.0 : 0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
