// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/utility/utility.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class CustomDataTable extends StatefulWidget {
  const CustomDataTable({
    required this.columns,
    required this.rows,
    super.key,
    this.scrollController,
    this.onRefresh,
    this.lastWidget = const SizedBox(),
    this.firstWidget = const SizedBox(),
    this.dataRowMaxHeight,
    this.dataRowMinHeight = 64,
    this.isPageLoading = false,
  });
  final ScrollController? scrollController;
  final VoidCallback? onRefresh;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final Widget lastWidget;
  final Widget firstWidget;
  final double? dataRowMaxHeight;
  final double? dataRowMinHeight;
  final bool isPageLoading;

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.firstWidget,
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.strokeColor),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: DataTable2(
                scrollController: widget.scrollController,
                border: TableBorder.symmetric(
                  outside: const BorderSide(
                    color: AppColors.border,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                horizontalMargin: 20,
                columnSpacing: 5,
                columns: widget.columns,
                headingRowColor: WidgetStateProperty.all(AppColors.tableGray),
                rows: widget.rows,
                paginationLoadingBuilder: () {
                  return widget.isPageLoading ? Utility.progressIndicator() : const SizedBox();
                },
              ),
            ),
          ),
        ),
        widget.lastWidget,
      ],
    );
  }
}
