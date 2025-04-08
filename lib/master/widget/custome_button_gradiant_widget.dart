import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/utility/extentions/colors_extnetions.dart';
import 'package:admin_kdv/utility/utility.dart';
import 'package:flutter/material.dart';

class CustomeButtonGradiantWidget extends StatelessWidget {
  const CustomeButtonGradiantWidget({
    super.key,
    this.child,
    this.height,
    this.isGradient = false,
    this.width,
    this.pading,
    this.margin,
    this.onTap,
    this.buttonText,
    this.isLoading = false,
    this.isUseContainerBorder = false,
    this.preIcon,
    this.textColor,
    this.fontSize,
    this.borderRadius,
    this.buttonColor = AppColors.primary,
    this.loadingSize,
  });
  final Widget? child;
  final double? height;
  final double? width;
  final bool isGradient;
  final EdgeInsetsGeometry? pading;
  final EdgeInsetsGeometry? margin;
  final String? buttonText;
  final void Function()? onTap;
  final bool isLoading;
  final bool isUseContainerBorder;
  final Widget? preIcon;
  final Color? textColor;
  final Color buttonColor;
  final double? fontSize;
  final BorderRadiusGeometry? borderRadius;
  final double? loadingSize;

  @override
  Widget build(BuildContext context) {
    if (!isGradient) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: pading,
          height: height ?? 44,
          width: width,
          margin: margin,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: isUseContainerBorder ? Border.all(color: AppColors.strokeColor) : null,
          ),
          child: (buttonText != null && !isLoading)
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    preIcon ?? const SizedBox.shrink(),
                    Text(
                      buttonText ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: fontSize ?? 15,
                            color: textColor ?? AppColors.subText,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                )
              : isLoading
                  ? Utility.progressIndicator(
                      size: loadingSize,
                    )
                  : child,
        ),
      );
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 44,
        width: width,
        margin: margin,
        padding: pading,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          color: buttonColor, // Background color #804EEC
          gradient: LinearGradient(
            colors: [
              buttonColor.withOpacity2(0.7), // Adjust opacity for gradient effect
              buttonColor, // Adjust opacity for gradient effect
              buttonColor, // Adjust opacity for gradient effect
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            // Second shadow (regular shadow)
            BoxShadow(
              color: AppColors.white.withOpacity2(0.25), // #FFFFFF40 is 25% opacity
              offset: const Offset(0, 11), // Move shadow down by 11px
              blurRadius: 13.8, // Blur of 13.8px
              spreadRadius: -1, // Nega
            ),
            // Simulate inset shadow with a gradient blending
            BoxShadow(
              color: AppColors.black.withOpacity2(0.1), // #0000001A is 10% opacity
              offset: const Offset(0, 4), // Offset down by 4px
              blurRadius: 4, // Blur of 4px
            ),
          ],
        ),
        child: (buttonText != null && !isLoading)
            ? Text(
                buttonText ?? '',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15, color: AppColors.white),
              )
            : isLoading
                ? Utility.progressIndicator(
                    color: AppColors.white,
                    size: loadingSize,
                  )
                : child,
      ),
    );
  }
}
