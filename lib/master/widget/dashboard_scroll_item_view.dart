import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/utility/extentions/colors_extnetions.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DashBoardScrollItemView extends StatelessWidget {
  const DashBoardScrollItemView({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final horizontalScrollController = ScrollController();
    final verticalScrollController = ScrollController();
    return getValueForScreenType(
      context: context,
      mobile: RawScrollbar(
        trackVisibility: false,
        thumbVisibility: true,
        controller: horizontalScrollController,
        thumbColor: AppColors.primary.withOpacity2(0.06),
        thickness: 10,
        crossAxisMargin: 1,
        radius: const Radius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: horizontalScrollController,
          child: RawScrollbar(
            thumbVisibility: true,
            controller: verticalScrollController,
            thumbColor: AppColors.primary.withOpacity2(0.06),
            thickness: 10,
            crossAxisMargin: 1,
            radius: const Radius.circular(20),
            child: SingleChildScrollView(
              controller: verticalScrollController,
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: screenWidth < 420 ? 420 : screenWidth,
                  minHeight: 770,
                  maxHeight: screenHeight < 770 ? 770 : screenHeight,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
      tablet: RawScrollbar(
        trackVisibility: false,
        thumbVisibility: true,
        controller: horizontalScrollController,
        thumbColor: AppColors.primary.withOpacity(0.6),
        thickness: 10,
        crossAxisMargin: 1,
        radius: const Radius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: horizontalScrollController,
          child: RawScrollbar(
            thumbVisibility: true,
            controller: verticalScrollController,
            thumbColor: AppColors.primary.withOpacity(0.6),
            thickness: 10,
            crossAxisMargin: 1,
            radius: const Radius.circular(20),
            child: SingleChildScrollView(
              controller: verticalScrollController,
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 600,
                  maxWidth: screenWidth < 600 ? 600 : screenWidth,
                  minHeight: 770,
                  maxHeight: screenHeight < 770 ? 770 : screenHeight,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
      desktop: RawScrollbar(
        trackVisibility: false,
        thumbVisibility: true,
        controller: horizontalScrollController,
        thumbColor: AppColors.primary.withOpacity(0.6),
        thickness: 10,
        crossAxisMargin: 1,
        radius: const Radius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: horizontalScrollController,
          child: RawScrollbar(
            thumbVisibility: true,
            controller: verticalScrollController,
            thumbColor: AppColors.primary.withOpacity(0.6),
            thickness: 10,
            crossAxisMargin: 1,
            radius: const Radius.circular(20),
            child: SingleChildScrollView(
              controller: verticalScrollController,
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 1260,
                  maxWidth: screenWidth < 1260 ? 1260 : screenWidth,
                  minHeight: 770,
                  maxHeight: screenHeight < 770 ? 770 : screenHeight,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
