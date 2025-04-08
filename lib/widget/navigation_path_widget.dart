import 'package:admin_kdv/constants/app_assets.dart';
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/master/widget/app_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NavigationPathWidget extends StatelessWidget {
  const NavigationPathWidget(
      {super.key, this.firstTitle, this.secondTitle, this.thirdTitle, this.secondTitleColor, this.mainTitle});
  final String? mainTitle;
  final String? firstTitle;
  final String? secondTitle;
  final String? thirdTitle;
  final Color? secondTitleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mainTitle ?? '',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const Gap(4),
        Row(
          children: [
            Text(
              firstTitle ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.subText),
            ),
            const Gap(2),
            const AppAssetImage(AppAssets.arrowRightIcon),
            const Gap(2),
            Text(
              secondTitle ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: secondTitleColor ?? AppColors.subText,
                  ),
            ),
            if (thirdTitle != null) ...[
              const Gap(2),
              const AppAssetImage(AppAssets.arrowRightIcon),
              const Gap(2),
              Text(
                thirdTitle ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
