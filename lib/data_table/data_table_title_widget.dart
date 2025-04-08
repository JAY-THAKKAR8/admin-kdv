// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:admin_kdv/constants/app_assets.dart';
import 'package:admin_kdv/master/widget/app_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DataTableTitleWidget extends StatelessWidget {
  const DataTableTitleWidget({
    required this.title,
    super.key,
    this.isTitle = false,
    this.isDiscending,
    this.bottomWidget,
    this.titleLeading,
    this.trailing = const [],
  });
  final String title;
  final bool isTitle;
  final bool? isDiscending;
  final Widget? bottomWidget;
  final Widget? titleLeading;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              if (titleLeading != null) ...[
                titleLeading!,
                const Gap(6),
              ],
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isTitle ? FontWeight.bold : FontWeight.w400,
                        fontSize: isTitle ? 15 : 14,
                      ),
                ),
              ),
              ...trailing,
              if (isDiscending != null) ...[
                const Gap(6),
                AppAssetImage(
                  isDiscending! ? AppAssets.descendingIcon : AppAssets.ascendingIcon,
                  height: 12,
                  width: 12,
                ),
              ],
            ],
          ),
        ),
        if (bottomWidget != null) ...[
          const Gap(6),
          bottomWidget!,
        ],
      ],
    );
  }
}
