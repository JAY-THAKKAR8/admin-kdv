import 'dart:developer';

import 'package:admin_kdv/constants/app_assets.dart';
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/constants/app_constants.dart';
import 'package:admin_kdv/constants/app_strings.dart';
import 'package:admin_kdv/data_table/data_table.dart';
import 'package:admin_kdv/data_table/data_table_title_widget.dart';
import 'package:admin_kdv/injector/injector.dart';
import 'package:admin_kdv/maintenance/model/maintenance_model.dart';
import 'package:admin_kdv/maintenance/repository/i_maintenance_repository.dart';
import 'package:admin_kdv/maintenance/view/add_maintenance_page.dart';
import 'package:admin_kdv/master/widget/app_text_form_field.dart';
import 'package:admin_kdv/master/widget/custome_button_gradiant_widget.dart';
import 'package:admin_kdv/user/model/user_model.dart';
import 'package:admin_kdv/user/repository/i_user_repository.dart';
import 'package:admin_kdv/utility/pagination_mixin.dart';
import 'package:admin_kdv/widget/app_drop_down_widget.dart';
import 'package:admin_kdv/widget/container_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> with PaginatisonMixin {
  final searchController = TextEditingController();

  final isLoading = ValueNotifier<bool>(false);
  final isLoadingMore = ValueNotifier<bool>(false);
  final isDeleteLoading = ValueNotifier<bool>(false);

  final maintenance = ValueNotifier<List<MaintenanceModel>>([]);
  final currentUser = ValueNotifier<UserModel?>(null);
  final selectedMonth = ValueNotifier<int?>(DateTime.now().month);
  final selectedYear = ValueNotifier<int>(DateTime.now().year);
  final selectedLine = ValueNotifier<String?>(null);
  final orderBy = ValueNotifier<String?>(null);
  final orderDirection = ValueNotifier<String?>(null);
  int page = 0;
  bool stopPagination = false;

  void _refresh() {
    page = 0;
    maintenance.value = [];
    getMaintenance();
  }

  @override
  void initState() {
    initiatePagination();
    getCurrentUser();
    getMaintenance();
    super.initState();
  }

  Future<void> getCurrentUser() async {
    final userResult = await getIt<IUserRepository>().getCurrentUser();
    userResult.fold(
      (l) {
        log("Error getting current user: ${l.message}");
      },
      (r) {
        currentUser.value = r;
        log("Current user: ${r.name}, Role: ${r.role}");
      },
    );
  }

  Future<void> getMaintenance() async {
    isLoading.value = true;
    maintenance.value = [];

    final failOrSuccess = selectedMonth.value != null
        ? await getIt<IMaintenanceRepository>().getMaintenanceByMonth(
            month: selectedMonth.value!,
            year: selectedYear.value,
          )
        : await getIt<IMaintenanceRepository>().getAllMaintenance();

    failOrSuccess.fold(
      (l) {
        isLoading.value = false;
        log("Error getting maintenance: ${l.message}");
      },
      (r) {
        maintenance.value = r;
        isLoading.value = false;
      },
    );
  }

  @override
  void dispose() {
    disposePagination();
    searchController.dispose();
    isLoading.dispose();
    isLoadingMore.dispose();
    isDeleteLoading.dispose();
    maintenance.dispose();
    currentUser.dispose();
    selectedMonth.dispose();
    selectedYear.dispose();
    selectedLine.dispose();
    orderBy.dispose();
    orderDirection.dispose();
    super.dispose();
  }

  @override
  void onReachedLast() {
    log('test onreached last');
    if (stopPagination || isLoadingMore.value || isLoading.value) return;
  }

  bool canAddMaintenance() {
    if (currentUser.value == null) return false;

    // Admin can add maintenance for any line
    if (currentUser.value!.role == AppConstants.admin) {
      return true;
    }

    // Line head can only add maintenance for their own line
    if (currentUser.value!.role == AppConstants.admin) {
      return true;
    }

    // Line members cannot add maintenance
    return false;
  }

  bool canAddMaintenanceForLine(String lineNumber) {
    if (currentUser.value == null) return false;

    // Admin can add maintenance for any line
    if (currentUser.value!.role == AppConstants.admin) {
      return true;
    }

    // Line head can only add maintenance for their own line
    if (currentUser.value!.role == AppConstants.lineLead) {
      return currentUser.value!.lineNumber == lineNumber;
    }

    // Line members cannot add maintenance
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ContainerWidget(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Maintenance',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24, letterSpacing: 0.5),
                    ),
                  ),
                  // Month filter dropdown
                  ValueListenableBuilder<int?>(
                    valueListenable: selectedMonth,
                    builder: (context, month, _) {
                      return SizedBox(
                        width: 150,
                        child: AppDropDown<int>(
                          title: 'Month',
                          hintText: 'Select Month',
                          selectedValue: month,
                          onSelect: (value) {
                            selectedMonth.value = value;
                            _refresh();
                          },
                          items: AppStrings.monthList
                              .map(
                                (e) => DropdownMenuItem<int>(
                                  value: e,
                                  child: Text(
                                    DateFormat('MMMM').format(DateTime(2022, e)),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                  const Gap(16),
                  AppTextFormField(
                    maxWidth: 280,
                    controller: searchController,
                    prefixIcon: AppAssets.searchIcon,
                    onChanged: (p0) {
                      EasyDebounce.debounce(
                        'search',
                        const Duration(milliseconds: 800),
                        _refresh,
                      );
                    },
                    hintText: 'Search',
                  ),
                  const Gap(16),
                  ValueListenableBuilder<UserModel?>(
                    valueListenable: currentUser,
                    builder: (context, user, _) {
                      return Visibility(
                        // visible: canAddMaintenance(),
                        child: CustomeButtonGradiantWidget(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddMaintenancePage(
                                  currentUser: user,
                                ),
                              ),
                            ).then((_) => _refresh());
                          },
                          height: 38,
                          width: 150,
                          isGradient: true,
                          child: Text(
                            '+ Add Maintenance',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontSize: 15, color: AppColors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const Gap(20),
              ValueListenableBuilder<List<MaintenanceModel>>(
                valueListenable: maintenance,
                builder: (context, maintenanceList, _) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: isLoading,
                    builder: (context, loading, _) {
                      if (loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (maintenanceList.isEmpty) {
                        return const Center(
                          child: Text('No maintenance records found'),
                        );
                      }

                      // Group maintenance by line
                      final Map<String, List<MaintenanceModel>> maintenanceByLine = {};
                      double totalAmount = 0;

                      for (var item in maintenanceList) {
                        if (item.lineNumber != null) {
                          if (!maintenanceByLine.containsKey(item.lineNumber)) {
                            maintenanceByLine[item.lineNumber!] = [];
                          }
                          maintenanceByLine[item.lineNumber!]!.add(item);
                          totalAmount += item.amount ?? 0;
                        }
                      }

                      return Expanded(
                        child: Column(
                          children: [
                            // Line-wise total collection
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Line-wise Total Collection',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const Gap(16),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Line',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Total Amount',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Records',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  ...maintenanceByLine.entries.map((entry) {
                                    final lineName = entry.key;
                                    final lineItems = entry.value;
                                    final lineTotal =
                                        lineItems.fold<double>(0, (sum, item) => sum + (item.amount ?? 0));

                                    String lineDisplayName = '';
                                    switch (lineName) {
                                      case AppConstants.firstLine:
                                        lineDisplayName = 'First Line';
                                        break;
                                      case AppConstants.secondLine:
                                        lineDisplayName = 'Second Line';
                                        break;
                                      case AppConstants.thirdLine:
                                        lineDisplayName = 'Third Line';
                                        break;
                                      case AppConstants.fourthLine:
                                        lineDisplayName = 'Fourth Line';
                                        break;
                                      case AppConstants.fifthLine:
                                        lineDisplayName = 'Fifth Line';
                                        break;
                                      default:
                                        lineDisplayName = lineName;
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              lineDisplayName,
                                              style: Theme.of(context).textTheme.bodyLarge,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              '₹${lineTotal.toStringAsFixed(2)}',
                                              style: Theme.of(context).textTheme.bodyLarge,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              lineItems.length.toString(),
                                              style: Theme.of(context).textTheme.bodyLarge,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: ValueListenableBuilder<UserModel?>(
                                              valueListenable: currentUser,
                                              builder: (context, user, _) {
                                                return Visibility(
                                                  // visible: canAddMaintenanceForLine(lineName),
                                                  child: CustomeButtonGradiantWidget(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => AddMaintenancePage(
                                                            currentUser: user,
                                                            preselectedLine: lineName,
                                                          ),
                                                        ),
                                                      ).then((_) => _refresh());
                                                    },
                                                    height: 30,
                                                    width: 80,
                                                    isGradient: true,
                                                    child: Text(
                                                      'Add',
                                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                            color: AppColors.white,
                                                          ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  const Divider(),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Total',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '₹${totalAmount.toStringAsFixed(2)}',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          maintenanceList.length.toString(),
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Gap(20),
                            // Detailed maintenance records
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Maintenance Records',
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    const Gap(16),
                                    Expanded(
                                      child: CustomDataTable(
                                        columns: const [
                                          DataColumn(label: DataTableTitleWidget(title: 'User')),
                                          DataColumn(label: DataTableTitleWidget(title: 'Line')),
                                          DataColumn(label: DataTableTitleWidget(title: 'Description')),
                                          DataColumn(label: DataTableTitleWidget(title: 'Amount')),
                                          DataColumn(label: DataTableTitleWidget(title: 'Date')),
                                          DataColumn(label: DataTableTitleWidget(title: 'Added By')),
                                          DataColumn(label: DataTableTitleWidget(title: 'Actions')),
                                        ],
                                        rows: maintenanceList.map((item) {
                                          String lineDisplayName = '';
                                          switch (item.lineNumber) {
                                            case AppConstants.firstLine:
                                              lineDisplayName = 'First Line';
                                              break;
                                            case AppConstants.secondLine:
                                              lineDisplayName = 'Second Line';
                                              break;
                                            case AppConstants.thirdLine:
                                              lineDisplayName = 'Third Line';
                                              break;
                                            case AppConstants.fourthLine:
                                              lineDisplayName = 'Fourth Line';
                                              break;
                                            case AppConstants.fifthLine:
                                              lineDisplayName = 'Fifth Line';
                                              break;
                                            default:
                                              lineDisplayName = item.lineNumber ?? '';
                                          }

                                          return DataRow(
                                            cells: [
                                              DataCell(Text(item.userName ?? '')),
                                              DataCell(Text(lineDisplayName)),
                                              DataCell(Text(item.description ?? '')),
                                              DataCell(Text('₹${(item.amount ?? 0).toStringAsFixed(2)}')),
                                              DataCell(Text(item.date != null
                                                  ? DateFormat('dd MMM yyyy').format(item.date!)
                                                  : '')),
                                              DataCell(Text(item.addedBy ?? '')),
                                              DataCell(
                                                ValueListenableBuilder<UserModel?>(
                                                  valueListenable: currentUser,
                                                  builder: (context, user, _) {
                                                    final bool canEdit = user != null &&
                                                        (user.role == AppConstants.admin ||
                                                            (user.role == AppConstants.lineLead &&
                                                                user.lineNumber == item.lineNumber));

                                                    return Row(
                                                      children: [
                                                        if (canEdit) ...[
                                                          IconButton(
                                                            icon: const Icon(Icons.edit, color: AppColors.primary),
                                                            onPressed: () {
                                                              // Navigate to edit page
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => AddMaintenancePage(
                                                                    currentUser: user,
                                                                    maintenanceId: item.id,
                                                                  ),
                                                                ),
                                                              ).then((_) => _refresh());
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(Icons.delete, color: Colors.red),
                                                            onPressed: () {
                                                              // Show delete confirmation
                                                              // showDialog(
                                                              //   context: context,
                                                              //   builder: (context) => CommonDailog(
                                                              //     title: 'Delete Maintenance',
                                                              //     content:
                                                              //         'Are you sure you want to delete this maintenance record?',
                                                              //     onConfirm: () async {
                                                              //       if (item.id != null) {
                                                              //         final result =
                                                              //             await getIt<IMaintenanceRepository>()
                                                              //                 .deleteMaintenance(
                                                              //                     maintenanceId: item.id!);
                                                              //         result.fold(
                                                              //           (l) {
                                                              //             Utility.toast(message: l.message);
                                                              //           },
                                                              //           (r) {
                                                              //             Utility.toast(
                                                              //                 message:
                                                              //                     'Maintenance deleted successfully');
                                                              //             _refresh();
                                                              //           },
                                                              //         );
                                                              //       }
                                                              //       if (mounted) {
                                                              //         Navigator.pop(context);
                                                              //       }
                                                              //     },
                                                              //   ),
                                                              // );
                                                            },
                                                          ),
                                                        ],
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
