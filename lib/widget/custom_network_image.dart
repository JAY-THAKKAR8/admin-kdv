// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:admin_kdv/constants/app_assets.dart';
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/constants/app_strings.dart';
import 'package:admin_kdv/utility/extentions/colors_extnetions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    required this.imageUrl,
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.isSmallImage = false,
  });
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool isSmallImage;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl.startsWith('http') ? imageUrl : AppStrings.storageBaseUrl + imageUrl;
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      memCacheHeight: isSmallImage ? 30 : null,
      memCacheWidth: isSmallImage ? 30 : null,
      errorWidget: (context, url, error) {
        return SvgPicture.asset(
          AppAssets.logo,
          height: height,
          width: width,
        );
      },
      placeholder: (context, url) {
        return Skeletonizer(
          child: Container(
            color: AppColors.white.withOpacity2(.5),
            height: height,
            width: width,
          ),
        );
      },
    );
  }
}
