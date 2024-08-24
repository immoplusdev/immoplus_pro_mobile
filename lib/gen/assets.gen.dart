/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/map.svg
  SvgGenImage get map => const SvgGenImage('assets/icons/map.svg');

  /// File path: assets/icons/add.svg
  SvgGenImage get add => const SvgGenImage('assets/icons/add.svg');

  /// File path: assets/icons/basket.svg
  SvgGenImage get basket => const SvgGenImage('assets/icons/basket.svg');

  /// File path: assets/icons/bell.svg
  SvgGenImage get bell => const SvgGenImage('assets/icons/bell.svg');

  /// File path: assets/icons/delet.svg
  SvgGenImage get delet => const SvgGenImage('assets/icons/delet.svg');

  /// File path: assets/icons/failed.svg
  SvgGenImage get failed => const SvgGenImage('assets/icons/failed.svg');

  /// File path: assets/icons/find.svg
  SvgGenImage get find => const SvgGenImage('assets/icons/find.svg');

  /// File path: assets/icons/go.svg
  SvgGenImage get go => const SvgGenImage('assets/icons/go.svg');

  /// File path: assets/icons/history.svg
  SvgGenImage get history => const SvgGenImage('assets/icons/history.svg');

  /// File path: assets/icons/home.svg
  SvgGenImage get home => const SvgGenImage('assets/icons/home.svg');

  /// File path: assets/icons/location.svg
  SvgGenImage get location => const SvgGenImage('assets/icons/location.svg');

  /// File path: assets/icons/pending.svg
  SvgGenImage get pending => const SvgGenImage('assets/icons/pending.svg');

  /// File path: assets/icons/profil.svg
  SvgGenImage get profil => const SvgGenImage('assets/icons/profil.svg');

  /// File path: assets/icons/search.svg
  SvgGenImage get search => const SvgGenImage('assets/icons/search.svg');

  /// File path: assets/icons/substract.svg
  SvgGenImage get substract => const SvgGenImage('assets/icons/substract.svg');

  /// File path: assets/icons/success.svg
  SvgGenImage get success => const SvgGenImage('assets/icons/success.svg');
}

class $AssetsImgGen {
  const $AssetsImgGen();

  /// File path: assets/img/img.png
  AssetGenImage get img => const AssetGenImage('assets/img/img.png');

  /// File path: assets/img/logo_plain.svg
  SvgGenImage get logoPlain => const SvgGenImage('assets/img/logo_plain.svg');

  /// File path: assets/img/void_image.jpeg
  AssetGenImage get voidImage =>
      const AssetGenImage('assets/img/void_image.png');
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImgGen img = $AssetsImgGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
    bool cacheColorFilter = false,
    SvgTheme? theme,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
      theme: theme,
    );
  }

  String get path => _assetName;
}
