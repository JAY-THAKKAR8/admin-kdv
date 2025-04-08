import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/theme/view/app_typography.dart';
import 'package:admin_kdv/utility/extentions/colors_extnetions.dart';
import 'package:flutter/material.dart';

class ThemeHelper {
  static TextTheme get lightTextTheme => TextTheme(
        displayLarge: LightAppTypography.displayLarge,
        displayMedium: LightAppTypography.displayMedium,
        displaySmall: LightAppTypography.displaySmall,
        headlineMedium: LightAppTypography.headlineMedium,
        headlineSmall: LightAppTypography.headlineSmall,
        titleLarge: LightAppTypography.titleLarge,
        titleMedium: LightAppTypography.titleMedium,
        titleSmall: LightAppTypography.titleSmall,
        bodyLarge: LightAppTypography.bodyLarge,
        bodyMedium: LightAppTypography.bodyMedium,
        bodySmall: LightAppTypography.bodySmall,
        labelLarge: LightAppTypography.labelLarge,
        labelMedium: LightAppTypography.labelMedium,
        labelSmall: LightAppTypography.labelSmall,
      );

  static InputDecorationTheme get inputDecorationLight {
    final commonBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none);

    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.gray,
      // contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 14),
      hintStyle:
          LightAppTypography.bodySmall.copyWith(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.subText),
      errorStyle: LightAppTypography.bodySmall.copyWith(fontSize: 12, color: AppColors.redOrange),
      counterStyle: LightAppTypography.bodySmall.copyWith(color: AppColors.black, fontSize: 10),
      errorMaxLines: 1,
      enabledBorder: commonBorder,
      focusedBorder: commonBorder,
      disabledBorder: commonBorder,
      errorBorder: commonBorder,
      focusedErrorBorder: commonBorder,
      border: commonBorder,
    );
  }

  static ElevatedButtonThemeData get elevatedButtonLight {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 12,
        shadowColor: AppColors.primary.withOpacity2(0.05),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        padding: const EdgeInsets.symmetric(vertical: 15),
        minimumSize: const Size(double.infinity, 0),
        textStyle: LightAppTypography.bodyMedium.copyWith(
          color: AppColors.white,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static DividerThemeData get dividerThemeLight {
    return const DividerThemeData(
      color: AppColors.strokeColor,
      thickness: 1,
      endIndent: 5,
      indent: 5,
    );
  }

  static ProgressIndicatorThemeData get progressIndicatorThemeLight {
    return const ProgressIndicatorThemeData(
      color: AppColors.primary,
      circularTrackColor: Colors.transparent,
    );
  }

  static ChipThemeData get chipThemeLight {
    return ChipThemeData(
      backgroundColor: AppColors.background,
      selectedColor: AppColors.primary,
      labelStyle: lightTextTheme.bodyMedium?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: lightTextTheme.bodyMedium?.copyWith(
        color: AppColors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static AppBarTheme get appBarThemeLight {
    return const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
    );
  }

  static TabBarTheme get tabBarThemeLight {
    return TabBarTheme(
      labelPadding: EdgeInsets.zero,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.greenDark,
      ),
      labelStyle: lightTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.white,
      ),
      unselectedLabelStyle: lightTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static TooltipThemeData get tooltipThemeLight {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity2(0.6),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: lightTextTheme.bodySmall?.copyWith(color: AppColors.white),
    );
  }

  static SwitchThemeData get switchThemeLight {
    return SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? AppColors.primary : AppColors.strokeColor,
      ),
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? AppColors.white : AppColors.subText,
      ),
    );
  }

  static DialogTheme get dialogThemeLight {
    return DialogTheme(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
