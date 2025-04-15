import 'package:admin_kdv/constants/app_assets.dart';
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/master/app_drawer.dart';
import 'package:admin_kdv/master/widget/app_asset_image.dart';
import 'package:admin_kdv/master/widget/dashboard_scroll_item_view.dart';
import 'package:admin_kdv/utility/extentions/context_extnetions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MasterPage extends StatefulWidget {
  const MasterPage({
    required this.navigationShell,
    super.key,
  });
  final StatefulNavigationShell navigationShell;

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashBoardScrollItemView(
      child: Scaffold(
        // backgroundColor: AppColors.background,
        key: _scaffoldKey,
        // backgroundColor: AppColors.background,
        appBar: !context.isDesktop
            ? AppBar(
                elevation: 0,
                // title: getTitle,
                centerTitle: false,
                backgroundColor: AppColors.white,
                leading: InkWell(
                  onTap: () => _scaffoldKey.currentState?.openDrawer(),
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: AppAssetImage(
                      AppAssets.drawerIcon,
                      height: 18,
                      width: 24,
                    ),
                  ),
                ),
              )
            : null,
        drawer: !context.isDesktop
            ? AppDrawer(currentIndex: widget.navigationShell.currentIndex, onChanged: _goBranch)
            : null,
        body: Row(
          children: [
            if (context.isDesktop) ...[
              AppDrawer(currentIndex: widget.navigationShell.currentIndex, onChanged: _goBranch),
              Expanded(
                child: widget.navigationShell,
              ),
            ] else
              Expanded(child: widget.navigationShell),
          ],
        ),
      ),
    );
  }

  String get title {
    switch (widget.navigationShell.currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'User';
      case 2:
        return 'Expenses';
      case 3:
        return 'Maintenance';
      default:
        return '';
    }
  }

  Text get getTitle => Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.black,
              fontSize: 18,
              letterSpacing: 1,
            ),
      );
}
