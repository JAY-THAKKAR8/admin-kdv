// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ChipTextWidget extends StatelessWidget {
  const ChipTextWidget({
    required this.text,
    required this.backgroundColor,
    this.textColor,
    super.key,
  });
  final String text;
  final Color backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor ?? AppColors.dark,
            ),
      ),
    );
  }
}
