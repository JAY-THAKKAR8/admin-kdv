import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/theme/view/theme_helper.dart';
import 'package:flutter/material.dart';

sealed class AppTheme {
  static ThemeData get light => ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        brightness: Brightness.light,
        textTheme: ThemeHelper.lightTextTheme,
        inputDecorationTheme: ThemeHelper.inputDecorationLight,
        elevatedButtonTheme: ThemeHelper.elevatedButtonLight,
        useMaterial3: false,
        dividerTheme: ThemeHelper.dividerThemeLight,
        progressIndicatorTheme: ThemeHelper.progressIndicatorThemeLight,
        chipTheme: ThemeHelper.chipThemeLight,
        appBarTheme: ThemeHelper.appBarThemeLight,
        tabBarTheme: ThemeHelper.tabBarThemeLight,
        tooltipTheme: ThemeHelper.tooltipThemeLight,
        switchTheme: ThemeHelper.switchThemeLight,
        dialogTheme: ThemeHelper.dialogThemeLight,
      );
}
