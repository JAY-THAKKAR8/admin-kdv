import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppAssetImage extends StatelessWidget {
  const AppAssetImage(
    this.assetName, {
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.color,
  });
  final String assetName;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      height: height,
      width: width,
      colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
      fit: fit,
    );
  }
}
