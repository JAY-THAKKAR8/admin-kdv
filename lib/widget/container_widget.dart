// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/utility/extentions/colors_extnetions.dart';
import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  const ContainerWidget({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.height,
    this.isUseBoxShadow = false,
    this.borderRadius,
    this.constraints,
  });
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final bool isUseBoxShadow;
  final BorderRadiusGeometry? borderRadius;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      margin: margin ?? const EdgeInsets.all(25),
      padding: padding ?? const EdgeInsets.all(20),
      constraints: constraints,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        color: AppColors.white,
        boxShadow: [
          if (isUseBoxShadow)
            BoxShadow(
              color: AppColors.black.withOpacity2(0.05),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
        ],
      ),
      child: child,
    );
  }
}
