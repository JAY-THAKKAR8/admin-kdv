import 'dart:developer';
import 'dart:js_interop';

import 'package:admin_kdv/app/routes/app_route.dart';
import 'package:admin_kdv/constants/app_assets.dart';
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/cubit/refresh_cubit.dart';
import 'package:admin_kdv/data_table/data_table.dart';
import 'package:admin_kdv/data_table/data_table_title_widget.dart';
import 'package:admin_kdv/enums/enum_file.dart';
import 'package:admin_kdv/expenses/model/expense_model.dart';
import 'package:admin_kdv/expenses/repository/i_expense_repository.dart';
import 'package:admin_kdv/injector/injector.dart';
import 'package:admin_kdv/master/widget/app_asset_image.dart';
import 'package:admin_kdv/master/widget/app_text_form_field.dart';
import 'package:admin_kdv/master/widget/custome_button_gradiant_widget.dart';
import 'package:admin_kdv/user/model/user_model.dart';
import 'package:admin_kdv/user/repository/i_user_repository.dart';
import 'package:admin_kdv/utility/pagination_mixin.dart';
import 'package:admin_kdv/utility/utility.dart';
import 'package:admin_kdv/widget/common_dailog.dart';
import 'package:admin_kdv/widget/container_widget.dart';
import 'package:admin_kdv/widget/custom_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ExpansePage extends StatefulWidget {
  const ExpansePage({super.key});

  @override
  State<ExpansePage> createState() => _ExpansePageState();
}

class _ExpansePageState extends State<ExpansePage> with PaginatisonMixin {
  final searchController = TextEditingController();

  final isLoading = ValueNotifier<bool>(false);
  final isLoadingMore = ValueNotifier<bool>(false);
  final isDeleteLoading = ValueNotifier<bool>(false);

  final expanses = ValueNotifier<List<ExpenseModel>>([]);
  final orderBy = ValueNotifier<String?>(null);
  final orderDirection = ValueNotifier<String?>(null);
  int page = 0;
  bool stopPagination = false;

  void _refresh() {
    page = 0;
    expanses.value = [];
    getExpanse();
  }

  @override
  void initState() {
    initiatePagination();
    getExpanse();
    super.initState();
  }

  Future<void> getExpanse() async {
    log("updated");
    isLoading.value = true;
    final failOrSucess = await getIt<IExpenseRepository>().getAllExpenses();
    failOrSucess.fold(
      (l) {
        isLoading.value = false;
        log(l.jsify().toString() + "expencse");
      },
      (r) {
        expanses.value = [...expanses.value, ...r];
        log(expanses.value.length.toString() + "total expanses");
        isLoading.value = false;
      },
    );
  }

  @override
  void dispose() {
    disposePagination();
    super.dispose();
  }

  @override
  void onReachedLast() {
    log('test onreached last');
    if (stopPagination || isLoadingMore.value || isLoading.value) return;
    // EasyDebounce.debounce('Select__User_Pagination', const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RefreshCubit, RefreshState>(
      listener: (context, state) {
        if (state is ModifyExpanse) {
          switch (state.action) {
            case ExpanseAction.add:
              expanses.value = [state.expanse, ...expanses.value];
            case ExpanseAction.edit:
              expanses.value = expanses.value.map((e) {
                if (e.id == state.expanse.id) {
                  return state.expanse;
                }
                return e;
              }).toList();
          }
        }
      },
      child: ContainerWidget(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Expenses',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24, letterSpacing: 0.5),
                  ),
                ),
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
                CustomeButtonGradiantWidget(
                  onTap: () {
                    context.goNamed(AppRoutes.addExpanses.name);
                  },
                  height: 38,
                  width: 113,
                  isGradient: true,
                  child: Text(
                    '+ Add Expanses',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 15, color: AppColors.white),
                  ),
                ),
              ],
            ),
            const Gap(16),
            Builder(
              builder: (context) {
                return Flexible(
                  child: ValueListenableBuilder(
                    valueListenable: expanses,
                    builder: (context, list, _) {
                      return ValueListenableBuilder(
                        valueListenable: isLoading,
                        builder: (context, loading, _) {
                          if (loading) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Utility.progressIndicator(),
                              ],
                            );
                          }
                          if (list.isEmpty && !loading) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Utility.noDataWidget(text: 'No Expenses Found', context: context),
                              ],
                            );
                          }
                          return ValueListenableBuilder(
                            valueListenable: orderBy,
                            builder: (context, orderByValue, _) {
                              return ValueListenableBuilder(
                                valueListenable: orderDirection,
                                builder: (context, direction, _) {
                                  return ValueListenableBuilder<bool>(
                                    valueListenable: isLoadingMore,
                                    builder: (context, loadingMore, _) {
                                      return CustomDataTable(
                                        scrollController: scrollPaginationController,
                                        isPageLoading: loadingMore,
                                        columns:const [
                                          DataColumn(
                                            label: DataTableTitleWidget(
                                              title: 'No.',
                                              isTitle: true,
                                            ),
                                          ),
                                          DataColumn(
                                            label: DataTableTitleWidget(
                                              title: 'Expense Name',
                                              isTitle: true,
                                              ),
                                          ),
                                          DataColumn(
                                            label: DataTableTitleWidget(
                                              title: 'Start Date',
                                              isTitle: true,
                                              ),
                                          ),
                                          DataColumn(
                                            label: DataTableTitleWidget(
                                              title: 'End Date',
                                              isTitle: true,
                                              
                                            ),
                                          ),
                                           DataColumn(
                                            label: DataTableTitleWidget(
                                              title: 'Total Expanse',
                                              isTitle: true,
                                            ),
                                          ),

                                           DataColumn(
                                            label: DataTableTitleWidget(
                                              title: 'Action',
                                              isTitle: true,
                                            ),
                                          ),
                                        ],
                                        rows: List.generate(
                                          list.length,
                                          (index) {
                                            final expanse = list[index];
                                            return DataRow(
                                              color: index.isEven
                                                  ? WidgetStateProperty.all(AppColors.white)
                                                  : WidgetStateProperty.all(AppColors.tableGray),
                                              cells: [
                                                DataCell(
                                                  DataTableTitleWidget(
                                                    title: (index + 1).toString(),
                                                  ),
                                                ),
                                                DataCell(
                                                  DataTableTitleWidget(
                                                    title: expanse.expenseName ?? '',
                                                    
                                                  ),
                                                ),
                                                DataCell(
                                                  DataTableTitleWidget(
                                                    title: DateFormat('yyyy-MM-dd').format(expanse.startDate!),
                                                  ),
                                                ),
                                                DataCell(
                                                  DataTableTitleWidget(
                                                    title: DateFormat('yyyy-MM-dd').format(expanse.endDate!),
                                                  ),
                                                ),
                                                DataCell(
                                                  DataTableTitleWidget(
                                                    title: expanse.totalExpense ?? '',
                                                  ),
                                                ),

                                                DataCell(
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          context.goNamed(
                                                            AppRoutes.editExpanses.name,
                                                            queryParameters: {'expenseId': expanse.id.toString()},
                                                          );
                                                        },
                                                        child: const AppAssetImage(
                                                          AppAssets.editIcon,
                                                        ),
                                                      ),
                                                      const Gap(8),
                                                      InkWell(
                                                        onTap: () {
                                                          //   deleteUser(
                                                          //   userId: user.id!,
                                                          //   userName: user.name ?? '',
                                                          // )
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) => CommonDailog(
                                                              title:
                                                                  'Are you sure you want to delete ${expanse.expenseName ?? ''}?',
                                                              onTap: () {
                                                                deleteUser(
                                                                  userId: expanse.id.toString(),
                                                                  userName: expanse.expenseName ?? '',
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        child: const AppAssetImage(
                                                          AppAssets.deleteIcon,
                                                        ),
                                                      ),
                                                      
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        lastWidget: const SizedBox.shrink(),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editUser({required String userId, required String? isVillaOpen}) async {
    final response = await getIt<IUserRepository>().updateCustomer(
      userId: userId,
      isVillaOpen: isVillaOpen,
    );
    await response.fold(
      (l) {
        Utility.toast(message: l.message);
      },
      (r) async {
        Utility.toast(message: 'User updated successfully');
        context.read<RefreshCubit>().modifyUser(r, UserAction.edit);
        context.pop();
      },
    );
  }

  Future<void> deleteUser({required String userId, required String userName}) async {
    final result = await getIt<IUserRepository>().deleteCustomer(userId: userId);
    await result.fold(
      (l) {
        Utility.toast(message: l.message);
      },
      (r) async {
        expanses.value = expanses.value.where((e) => e.id != userId).toList();

        context.pop();
      },
    );
  }
}
