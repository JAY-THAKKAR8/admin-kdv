import 'package:admin_kdv/constants/app_assets.dart';
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/master/widget/app_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppDropDown<T> extends StatelessWidget {
  const AppDropDown({
    required this.onSelect,
    required this.items,
    super.key,
    this.validator,
    this.selectedValue,
    this.hintText,
    this.title,
    this.maxWidth,
    this.maxHeight,
    this.contentPadding,
  });
  final Function(T? valueOfCategory) onSelect;
  final String? Function(T?)? validator;

  final T? selectedValue;
  final String? hintText;
  final List<DropdownMenuItem<T>>? items;
  final String? title;
  final double? maxWidth;
  final double? maxHeight;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subText,
                ),
          ),
          const Gap(6),
        ],
        DropdownButtonFormField<T>(
          value: selectedValue,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          onChanged: onSelect,
          hint: Text(
            hintText ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? 400,
            ),
          ),
          validator: validator,
          icon: const AppAssetImage(AppAssets.arrowDownIcon),
          items: items,
        ),
      ],
    );
  }
}
