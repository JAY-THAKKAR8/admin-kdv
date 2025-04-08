import 'package:admin_kdv/constants/app_colors.dart';
import 'package:flutter/material.dart';

extension ColorsExtnetions on Color {
  Color withOpacity2(double opacity) {
    return Color.fromRGBO(red, green, blue, opacity);
  }

  Color get getContrastingColor => computeLuminance() >= 0.5 ? AppColors.dark : Colors.white;
}
