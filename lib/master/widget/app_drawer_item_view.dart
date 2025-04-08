// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/master/widget/app_asset_image.dart';
import 'package:admin_kdv/master/widget/custome_button_gradiant_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppDrawerItemView extends StatelessWidget {
  const AppDrawerItemView({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
    this.isSelecetd = false,
  });
  final String title;
  final String icon;
  final bool isSelecetd;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomeButtonGradiantWidget(
      onTap: onTap,
      isGradient: isSelecetd,
      pading: const EdgeInsets.symmetric(horizontal: 27, vertical: 11),
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          AppAssetImage(
            icon,
            height: 22,
            width: 22,
          ),
          const Gap(16),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  color: isSelecetd ? AppColors.white : AppColors.drawerTextColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
          ),
        ],
      ),
    );
  }
}
