// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/master/widget/app_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.title,
    this.hintText,
    this.enabled,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.textInputAction,
    this.contentPadding,
    this.onFieldSubmitted,
    this.onTap,
    this.onChanged,
    this.obscuringCharacter,
    this.maxWidth,
    this.maxHeight,
    this.fillColor,
    this.inputFormatters,
    this.style,
    this.keyboardType,
    this.hintStyle,
    this.focusNode,
  });
  final TextEditingController? controller;
  final String? title;
  final String? hintText;
  final bool? enabled;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final String? prefixIcon;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final String? obscuringCharacter;
  final double? maxWidth;
  final double? maxHeight;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: Text(
              title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.subText,
                  ),
            ),
          ),
          const Gap(6),
        ],
        TextFormField(
          controller: controller,
          enabled: enabled,
          validator: validator,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter ?? '•',
          maxLines: maxLines,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          onTap: onTap,
          readOnly: readOnly,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          style: style,
          onChanged: onChanged,
          decoration: InputDecoration(
            // isDense: true,
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? 400,
              maxHeight: maxHeight ?? double.infinity,
            ),
            hintText: hintText,
            fillColor: fillColor,
            filled: true,
            suffixIcon: suffixIcon,
            hintStyle: hintStyle,
            contentPadding: contentPadding,
          ),
        ),
      ],
    );
  }
}
