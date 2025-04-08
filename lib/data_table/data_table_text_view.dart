// ignore_for_file: public_member_api_docs, sort_constructors
import 'package:admin_kdv/constants/app_assets.dart';
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/master/widget/app_asset_image.dart';
import 'package:admin_kdv/master/widget/custome_button_gradiant_widget.dart';
import 'package:admin_kdv/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DataTableTextView extends StatelessWidget {
  const DataTableTextView({
    this.text,
    super.key,
    this.maxWidth,
    this.isTitle = false,
    this.textColor,
    this.textDecoration,
    this.isUseSortingIcon = true,
    this.isDiscending = false,
    this.onTap,
    this.padding,
    this.isUserImage = false,
    this.onViewTap,
    this.onEditTap,
    this.onDeleteTap,
    this.subText,
    this.subText2,
    this.isRollManagementCheckBoxUse = false,
    this.isCheckBoxImage,
    this.onAddEditOnTap,
    this.statusText,
    this.statusBgColor,
    this.subTextBgColor,
  });

  final String? text;
  final String? subText;
  final String? subText2;
  final String? statusText;
  final Color? statusBgColor;
  final Color? subTextBgColor;
  final double? maxWidth;
  final bool isTitle;
  final bool isUseSortingIcon;
  final Color? textColor;
  final TextDecoration? textDecoration;
  final void Function()? onTap;
  final void Function()? onViewTap;
  final void Function()? onEditTap;
  final void Function()? onDeleteTap;
  final void Function()? onAddEditOnTap;
  final EdgeInsetsGeometry? padding;
  final bool isDiscending;
  final bool isUserImage;
  final bool isRollManagementCheckBoxUse;
  final String? isCheckBoxImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? 300,
          ),
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onAddEditOnTap == null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    if (isUserImage) ...[
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Utility.imageLoader(
                                          url: '',
                                          placeholder: AppAssets.greyBackgroundIcon,
                                        ),
                                      ),
                                      const Gap(5),
                                    ],
                                    Text(
                                      text ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            fontWeight: isTitle ? FontWeight.bold : FontWeight.w400,
                                            fontSize: isTitle ? 15 : 14,
                                            decoration: textDecoration,
                                            color: isTitle ? AppColors.dark : textColor ?? AppColors.dark,
                                          ),
                                    ),
                                  ],
                                ),
                                if (subText != null) ...[
                                  const Gap(8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.skinColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      subText ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.dark,
                                          ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isTitle && isUseSortingIcon) ...[
                        const Gap(6),
                        AppAssetImage(
                          isDiscending ? AppAssets.descendingIcon : AppAssets.ascendingIcon,
                          height: 12,
                          width: 12,
                        ),
                      ],
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (onViewTap != null) ...[
                              const AppAssetImage(
                                AppAssets.viewIcon,
                              ),
                              const Gap(16),
                            ],
                            if (onEditTap != null) ...[
                              const AppAssetImage(
                                AppAssets.editIcon,
                              ),
                              const Gap(16),
                            ],
                            if (onDeleteTap != null) ...[
                              const AppAssetImage(
                                AppAssets.deleteIcon,
                              ),
                            ],
                            if (isRollManagementCheckBoxUse)
                              AppAssetImage(
                                height: 20,
                                width: 20,
                                isCheckBoxImage ?? '',
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (onAddEditOnTap != null || subText2 != null) ...[
                  const Gap(8),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (onAddEditOnTap != null) ...[
                          Flexible(
                            child: CustomeButtonGradiantWidget(
                              onTap: onAddEditOnTap,
                              borderRadius: BorderRadius.circular(5),
                              height: 26,
                              width: 59,
                              isGradient: true,
                              child: Text(
                                '+ Add',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontSize: 15, color: AppColors.white),
                              ),
                            ),
                          ),
                          const Gap(10),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: subTextBgColor ?? AppColors.skinColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            subText2 ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.dark,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
