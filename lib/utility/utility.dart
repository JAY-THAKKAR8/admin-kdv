import 'package:admin_kdv/constants/app_assets.dart';
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Utility {
  static Widget progressIndicator({Color? color, double? size}) {
    return Center(
      child: Image.asset(
        AppAssets.loadingGif,
        fit: BoxFit.fill,
        height: size ?? 50,
        width: size ?? 50,
        color: color ?? AppColors.primary,
      ),
    );
  }

  static bool isValidEmail(String email) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
  }

  static Widget noDataWidget({required String text, required BuildContext context}) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.subText),
    );
  }

  static Widget imageLoader({
    required String url,
    required String placeholder,
    BoxFit? fit,
    BuildContext? context,
    bool isShapeCircular = false,
    BorderRadius? borderRadius,
    Widget? loadingWidget,
    BoxShape? shape,
  }) {
    if (url.trim() == '') {
      return Container(
        decoration: BoxDecoration(
          shape: shape ?? BoxShape.rectangle,
          borderRadius: isShapeCircular ? null : borderRadius ?? BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(placeholder),
            fit: fit ?? BoxFit.cover,
          ),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fadeInDuration: const Duration(seconds: 5),
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: isShapeCircular ? null : borderRadius ?? BorderRadius.circular(10),
            // borderRadius: borderRadius ?? BorderRadius.circular(10),
            shape: shape ?? BoxShape.rectangle,
            image: DecorationImage(
              image: imageProvider,
              fit: fit ?? BoxFit.cover,
            ),
          ),
        );
      },
      errorWidget: (context, error, dynamic a) => Container(
        decoration: BoxDecoration(
          shape: shape ?? BoxShape.rectangle,
          borderRadius: isShapeCircular ? null : borderRadius ?? BorderRadius.circular(10),
          // borderRadius: borderRadius ??  BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(placeholder),
            fit: fit ?? BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) =>
          loadingWidget ??
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xffebebeb)),
          ),
    );
  }

  static void toast({
    required String? message,
  }) {
    if (message == null || message.trim().isEmpty) return;
    BotToast.showText(
      text: message,
      clickClose: true,
      align: const Alignment(0, 0.85),
      duration: const Duration(seconds: 3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
