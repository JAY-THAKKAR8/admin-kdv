import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/constants/app_constants.dart';
import 'package:admin_kdv/constants/app_strings.dart';
import 'package:admin_kdv/injector/injector.dart';
import 'package:admin_kdv/maintenance/repository/i_maintenance_repository.dart';
import 'package:admin_kdv/master/widget/app_text_form_field.dart';
import 'package:admin_kdv/master/widget/custome_button_gradiant_widget.dart';
import 'package:admin_kdv/user/model/user_model.dart';
import 'package:admin_kdv/user/repository/i_user_repository.dart';
import 'package:admin_kdv/utility/utility.dart';
import 'package:admin_kdv/widget/app_drop_down_widget.dart';
import 'package:admin_kdv/widget/container_widget.dart';
import 'package:admin_kdv/widget/navigation_path_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddMaintenancePage extends StatefulWidget {
  final UserModel? currentUser;
  final String? maintenanceId;
  final String? preselectedLine;

  const AddMaintenancePage({
    this.currentUser,
    this.maintenanceId,
    this.preselectedLine,
    super.key,
  });

  @override
  State<AddMaintenancePage> createState() => _AddMaintenancePageState();
}

class _AddMaintenancePageState extends State<AddMaintenancePage> {
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final isButtonLoading = ValueNotifier<bool>(false);
  final isLoading = ValueNotifier<bool>(false);
  final selectedUser = ValueNotifier<UserModel?>(null);
  final selectedLine = ValueNotifier<String?>(null);
  final users = ValueNotifier<List<UserModel>>([]);

  @override
  void initState() {
    super.initState();
    dateController.text = DateTime.now().toString().split(' ')[0];

    if (widget.preselectedLine != null) {
      selectedLine.value = widget.preselectedLine;
    } else if (widget.currentUser?.role == AppConstants.lineLead) {
      selectedLine.value = widget.currentUser?.lineNumber;
    }

    getUsers();

    if (widget.maintenanceId != null) {
      getMaintenanceData();
    }
  }

  Future<void> getMaintenanceData() async {
    isLoading.value = true;
    final result = await getIt<IMaintenanceRepository>().getMaintenance(maintenanceId: widget.maintenanceId!);
    result.fold(
      (l) {
        isLoading.value = false;
        Utility.toast(message: l.message);
      },
      (r) {
        descriptionController.text = r.description ?? '';
        amountController.text = (r.amount ?? 0).toString();
        if (r.date != null) {
          dateController.text = r.date.toString().split(' ')[0];
        }
        selectedLine.value = r.lineNumber;

        // Find the user in the users list
        if (r.userId != null) {
          for (var user in users.value) {
            if (user.id == r.userId) {
              selectedUser.value = user;
              break;
            }
          }
        }

        isLoading.value = false;
      },
    );
  }

  Future<void> getUsers() async {
    isLoading.value = true;
    final result = await getIt<IUserRepository>().getAllUsers();
    result.fold(
      (l) {
        isLoading.value = false;
        Utility.toast(message: l.message);
      },
      (r) {
        // If line head, filter users by line
        if (widget.currentUser?.role == AppConstants.lineLead && widget.currentUser?.lineNumber != null) {
          users.value = r.where((user) => user.lineNumber == widget.currentUser?.lineNumber).toList();
        } else {
          users.value = r;
        }
        isLoading.value = false;
      },
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    amountController.dispose();
    dateController.dispose();
    isButtonLoading.dispose();
    isLoading.dispose();
    selectedUser.dispose();
    selectedLine.dispose();
    users.dispose();
    super.dispose();
  }

  /// Select date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? currentDate = dateController.text.isNotEmpty ? DateTime.parse(dateController.text) : null;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      dateController.text = picked.toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.maintenanceId != null ? 'Edit Maintenance' : 'Add Maintenance',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.black,
                fontSize: 18,
                letterSpacing: 1,
              ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, loading, _) {
          if (loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ContainerWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavigationPathWidget(
                      mainTitle: widget.maintenanceId != null ? 'Edit Maintenance' : 'Add Maintenance',
                      firstTitle: 'Home',
                      secondTitle: 'Maintenance',
                      thirdTitle: widget.maintenanceId != null ? 'Edit Maintenance' : 'Add Maintenance',
                      secondTitleColor: AppColors.primary,
                    ),
                    const Gap(20),

                    // User selection
                    ValueListenableBuilder<UserModel?>(
                      valueListenable: selectedUser,
                      builder: (context, selectedUserValue, _) {
                        return AppDropDown<UserModel>(
                          title: 'User*',
                          hintText: 'Select User',
                          selectedValue: selectedUserValue,
                          onSelect: (user) {
                            selectedUser.value = user;
                            // If user has a line, set the line automatically
                            if (user?.userLineViewString != null) {
                              selectedLine.value = user?.userLineViewString;
                            }
                          },
                          items: users.value
                              .map(
                                (e) => DropdownMenuItem<UserModel>(
                                  value: e,
                                  child: Text(
                                    '${e.name} (${e.userRoleViewString})',
                                  ),
                                ),
                              )
                              .toList(),
                          validator: (p0) {
                            if (p0 == null) {
                              return 'Please select user';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const Gap(20),

                    // Line selection
                    ValueListenableBuilder<String?>(
                      valueListenable: selectedLine,
                      builder: (context, lineValue, _) {
                        return AppDropDown<String>(
                          title: 'Line*',
                          hintText: 'Select Line',
                          selectedValue: lineValue,
                          onSelect: (line) {
                            selectedLine.value = line;
                          },
                          items: widget.currentUser?.role == AppConstants.lineLead
                              ? [
                                  DropdownMenuItem<String>(
                                    value: widget.currentUser?.lineNumber,
                                    child: Text(
                                      widget.currentUser?.userLineViewString ?? '',
                                    ),
                                  ),
                                ]
                              : AppStrings.lineList
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: _getLineConstant(e),
                                      child: Text(
                                        e,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          validator: (p0) {
                            if (p0 == null || p0.trim().isEmpty) {
                              return 'Please select line';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const Gap(20),

                    // Description
                    AppTextFormField(
                      controller: descriptionController,
                      title: 'Description*',
                      hintText: 'Enter description',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),

                    // Amount
                    AppTextFormField(
                      controller: amountController,
                      title: 'Amount*',
                      hintText: 'Enter amount',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),

                    // Date
                    AppTextFormField(
                      controller: dateController,
                      readOnly: true,
                      title: 'Date*',
                      onTap: () => _selectDate(context),
                      validator: (value) => value!.isEmpty ? 'Please select date' : null,
                    ),
                    const Gap(30),

                    // Submit button
                    ValueListenableBuilder<bool>(
                      valueListenable: isButtonLoading,
                      builder: (_, value, __) {
                        return CustomeButtonGradiantWidget(
                          buttonText: widget.maintenanceId != null ? 'Update' : 'Submit',
                          isLoading: value,
                          isGradient: true,
                          onTap: () {
                            if (widget.maintenanceId != null) {
                              updateMaintenance();
                            } else {
                              createMaintenance();
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getLineConstant(String lineDisplayName) {
    switch (lineDisplayName) {
      case 'First line':
        return AppConstants.firstLine;
      case 'Second line':
        return AppConstants.secondLine;
      case 'Third line':
        return AppConstants.thirdLine;
      case 'Fourth line':
        return AppConstants.fourthLine;
      case 'Fifth line':
        return AppConstants.fifthLine;
      default:
        return AppConstants.firstLine;
    }
  }

  Future<void> createMaintenance() async {
    if (_formKey.currentState!.validate() && selectedUser.value != null) {
      isButtonLoading.value = true;
      final response = await getIt<IMaintenanceRepository>().addMaintenance(
        userId: selectedUser.value!.id!,
        userName: selectedUser.value!.name!,
        lineNumber: selectedLine.value!,
        description: descriptionController.text.trim(),
        amount: double.parse(amountController.text.trim()),
        date: DateTime.parse(dateController.text),
        addedBy: widget.currentUser?.name ?? 'Unknown',
        addedById: widget.currentUser?.id ?? '',
      );

      response.fold(
        (l) {
          isButtonLoading.value = false;
          Utility.toast(message: l.message);
        },
        (r) {
          isButtonLoading.value = false;
          Utility.toast(message: 'Maintenance added successfully');
          Navigator.pop(context);
        },
      );
    }
  }

  Future<void> updateMaintenance() async {
    if (_formKey.currentState!.validate() && selectedUser.value != null) {
      isButtonLoading.value = true;
      final response = await getIt<IMaintenanceRepository>().updateMaintenance(
        maintenanceId: widget.maintenanceId!,
        userId: selectedUser.value!.id,
        userName: selectedUser.value!.name,
        lineNumber: selectedLine.value,
        description: descriptionController.text.trim(),
        amount: double.parse(amountController.text.trim()),
        date: DateTime.parse(dateController.text),
      );

      response.fold(
        (l) {
          isButtonLoading.value = false;
          Utility.toast(message: l.message);
        },
        (r) {
          isButtonLoading.value = false;
          Utility.toast(message: 'Maintenance updated successfully');
          Navigator.pop(context);
        },
      );
    }
  }
}
