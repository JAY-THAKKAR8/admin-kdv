import 'dart:developer';

import 'package:admin_kdv/app/routes/app_route.dart';
import 'package:admin_kdv/constants/app_assets.dart';
import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/cubit/refresh_cubit.dart';
import 'package:admin_kdv/data_table/data_table.dart';
import 'package:admin_kdv/data_table/data_table_title_widget.dart';
import 'package:admin_kdv/enums/enum_file.dart';
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

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> with PaginatisonMixin {
  final searchController = TextEditingController();

  final isLoading = ValueNotifier<bool>(false);
  final isLoadingMore = ValueNotifier<bool>(false);
  final isDeleteLoading = ValueNotifier<bool>(false);

  final users = ValueNotifier<List<UserModel>>([]);
  final orderBy = ValueNotifier<String?>(null);
  final orderDirection = ValueNotifier<String?>(null);
  int page = 0;
  bool stopPagination = false;

  void _refresh() {
    page = 0;
    users.value = [];
    // getUsers();
  }

  @override
  void initState() {
    initiatePagination();
    getUsers();
    super.initState();
  }

  Future<void> getUsers() async {
    isLoading.value = true;
    final failOrSucess = await getIt<IUserRepository>().getAllUsers();
    failOrSucess.fold(
      (l) {
        isLoading.value = false;
      },
      (r) {
        users.value = [...users.value, ...r];
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
        if (state is ModifyUser) {
          switch (state.action) {
            case UserAction.add:
              users.value = [state.user, ...users.value];
            case UserAction.edit:
              users.value = users.value.map((e) {
                if (e.id == state.user.id) {
                  return state.user;
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
                    'Users',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24, letterSpacing: 0.5),
                  ),
                ),
                AppTextFormField(
                  maxWidth: 250,
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
                    context.goNamed(AppRoutes.addUser.name);
                  },
                  height: 38,
                  width: 113,
                  isGradient: true,
                  child: Text(
                    '+ New User',
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
                    valueListenable: users,
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
                                Utility.noDataWidget(text: 'No User Found', context: context),
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
                                        columns: [
                                          const DataColumn(
                                            label: DataTableTitleWidget(
                                              title: 'V.No.',
                                              isTitle: true,
                                            ),
                                          ),
                                          DataColumn(
                                            label: DataTableTitleWidget(
                                              title: 'User',
                                              isTitle: true,
                                              isDiscending: orderByValue == 'name' ? direction == 'DESC' : null,
                                            ),
                                          ),
                                          DataColumn(
                                            label: DataTableTitleWidget(
                                              title: 'Email',
                                              isTitle: true,
                                              isDiscending: orderByValue == 'email' ? direction == 'DESC' : null,
                                            ),
                                          ),
                                          const DataColumn(
                                            label: DataTableTitleWidget(
                                              title: 'Role',
                                              isTitle: true,
                                            ),
                                          ),
                                          const DataColumn(
                                            label: DataTableTitleWidget(
                                              title: 'Line Number',
                                              isTitle: true,
                                            ),
                                          ),
                                          const DataColumn(
                                            label: DataTableTitleWidget(
                                              title: 'Action',
                                              isTitle: true,
                                            ),
                                          ),
                                        ],
                                        rows: List.generate(
                                          list.length,
                                          (index) {
                                            final user = list[index];
                                            return DataRow(
                                              color: index.isEven
                                                  ? WidgetStateProperty.all(AppColors.white)
                                                  : WidgetStateProperty.all(AppColors.tableGray),
                                              cells: [
                                                DataCell(
                                                  DataTableTitleWidget(
                                                    title: user.villNumber ?? '',
                                                  ),
                                                ),
                                                DataCell(
                                                  DataTableTitleWidget(
                                                    title: user.name ?? '',
                                                    titleLeading: ClipRRect(
                                                      borderRadius: BorderRadius.circular(100),
                                                      child: CustomNetworkImage(
                                                        imageUrl: user.imagePath ?? '',
                                                        height: 24,
                                                        width: 24,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  DataTableTitleWidget(
                                                    title: user.email ?? '',
                                                  ),
                                                ),
                                                DataCell(
                                                  DataTableTitleWidget(
                                                    title: user.role ?? 'User',
                                                  ),
                                                ),
                                                DataCell(
                                                  DataTableTitleWidget(
                                                    title: user.lineNumber ?? (index + 1).toString(),
                                                  ),
                                                ),
                                                DataCell(
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          context.goNamed(
                                                            AppRoutes.editUser.name,
                                                            queryParameters: {'userId': user.id.toString()},
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
                                                                  'Are you sure you want to delete ${user.name ?? ''}?',
                                                              onTap: () {
                                                                deleteUser(
                                                                  userId: user.id.toString(),
                                                                  userName: user.name ?? '',
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        child: const AppAssetImage(
                                                          AppAssets.deleteIcon,
                                                        ),
                                                      ),
                                                      Transform.scale(
                                                        scale: 0.7,
                                                        child: CupertinoSwitch(
                                                          value: user.isVillaOpen == '1',
                                                          // activeTrackColor: AppColors.primary,
                                                          onChanged: (value) {
                                                            EasyDebounce.debounce(
                                                                'Switch_User_Active', const Duration(milliseconds: 100),
                                                                () {
                                                              users.value = users.value
                                                                  .map(
                                                                    (e) => e.id == user.id
                                                                        ? e.copyWith(isVillaOpen: value ? '1' : '0')
                                                                        : e,
                                                                  )
                                                                  .toList();
                                                              editUser(
                                                                userId: user.id.toString(),
                                                                isVillaOpen: value ? '1' : '0',
                                                              );
                                                            });
                                                          },
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
        users.value = users.value.where((e) => e.id != userId).toList();

        context.pop();
      },
    );
  }
}
