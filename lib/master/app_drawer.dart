import 'package:admin_kdv/constants/app_assets.dart';
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/master/widget/app_drawer_item_view.dart';
import 'package:admin_kdv/utility/extentions/context_extnetions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    required this.currentIndex,
    required this.onChanged,
    super.key,
  });
  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      constraints: const BoxConstraints(maxWidth: 287),
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Row(
              children: [
                const Gap(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'KDV',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.dark,
                            ),
                      ),
                      Text(
                        'Management',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(30),
          AppDrawerItemView(
            title: 'Home',
            icon: currentIndex == 0 ? AppAssets.selectedHomeIcon : AppAssets.unselectedHomeIcon,
            isSelecetd: currentIndex == 0,
            onTap: () {
              if (context.isMobile) {
                Navigator.pop(context);
              }
              onChanged.call(0);
            },
          ),
          AppDrawerItemView(
            title: 'Users',
            icon: currentIndex == 1 ? AppAssets.selectedUserIcon : AppAssets.unselectedUserIcon,
            isSelecetd: currentIndex == 1,
            onTap: () {
              if (context.isMobile) {
                Navigator.pop(context);
              }
              onChanged.call(1);
            },
          ),
          AppDrawerItemView(
            title: 'Expenses',
            icon: currentIndex == 2 ? AppAssets.selectedUserIcon : AppAssets.unselectedUserIcon,
            isSelecetd: currentIndex == 2,
            onTap: () {
              if (context.isMobile) {
                Navigator.pop(context);
              }
              onChanged.call(2);
            },
          ),
          AppDrawerItemView(
            title: 'Maintenance',
            icon: currentIndex == 3 ? AppAssets.selectedUserIcon : AppAssets.unselectedUserIcon,
            isSelecetd: currentIndex == 3,
            onTap: () {
              if (context.isMobile) {
                Navigator.pop(context);
              }
              onChanged.call(3);
            },
          ),
          AppDrawerItemView(
            title: 'Logout',
            icon: AppAssets.unselectedLogoutIcon,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
