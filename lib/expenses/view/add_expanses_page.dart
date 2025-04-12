// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:admin_kdv/constants/app_colors.dart';
import 'package:admin_kdv/cubit/refresh_cubit.dart';
import 'package:admin_kdv/enums/enum_file.dart';
import 'package:admin_kdv/expenses/model/expense_item_model.dart';
import 'package:admin_kdv/expenses/repository/i_expense_repository.dart';
import 'package:admin_kdv/injector/injector.dart';
import 'package:admin_kdv/master/widget/app_text_form_field.dart';
import 'package:admin_kdv/master/widget/custome_button_gradiant_widget.dart';
import 'package:admin_kdv/utility/utility.dart';
import 'package:admin_kdv/widget/container_widget.dart';
import 'package:admin_kdv/widget/navigation_path_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddExpansePage extends StatefulWidget {
  const AddExpansePage({
    super.key,
    this.expanseId,
  });

  final String? expanseId;

  @override
  State<AddExpansePage> createState() => _AddExpansePageState();
}

class _AddExpansePageState extends State<AddExpansePage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final isButtonLoading = ValueNotifier<bool>(false);
  final isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<ExpenseItemModel>> expenseItems = ValueNotifier<List<ExpenseItemModel>>([
    ExpenseItemModel(
      nameController: TextEditingController(),
      priceController: TextEditingController(),
    )
  ]);
  @override
  void initState() {
    super.initState();
    log("message 536256");
    if (widget.expanseId != null) {
      getExpenseData();
      log("message");
    }
  }

  Future<void> getExpenseData() async {
    isLoading.value = true;
    final response = await getIt<IExpenseRepository>().getExpense(expenseId: widget.expanseId!);
    response.fold(
      (l) {
        isLoading.value = false;
        log("${l.message} + update value");
        Utility.toast(message: l.message);
      },
      (r) {
        titleController.text = r.expenseName ?? '';
        startDateController.text = r.startDate?.toString().split(' ')[0] ?? '';
        endDateController.text = r.endDate?.toString().split(' ')[0] ?? '';
        totalExpense.value = double.parse(r.totalExpense ?? '0.0');

        final items = r.expenseItems;

        log("${items.length} length of striong");

        if (r.expenseItems.isNotEmpty) {
          log("message fdhfj");

          expenseItems.value = items
              .map((item) => ExpenseItemModel(
                    nameController: TextEditingController(text: item.nameController.text),
                    priceController: TextEditingController(text: item.priceController.text),
                  ))
              .toList();
        }

        isLoading.value = false;
      },
    );
  }

  final ValueNotifier<double> totalExpense = ValueNotifier<double>(0.0);

  @override
  void dispose() {
    titleController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    isButtonLoading.dispose();
    expenseItems.dispose();
    totalExpense.dispose();
    super.dispose();
  }

  /// Updates the total expense calculation
  void updateTotalExpense() {
    double total = 0.0;
    for (var item in expenseItems.value) {
      total += double.tryParse(item.priceController.text) ?? 0.0;
    }
    totalExpense.value = total;
  }

  /// Select date picker
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final bool isStartDate = controller == startDateController;
    final DateTime now = DateTime.now();
    final DateTime? currentStartDate =
        startDateController.text.isNotEmpty ? DateTime.parse(startDateController.text) : null;
    final DateTime? currentEndDate = endDateController.text.isNotEmpty ? DateTime.parse(endDateController.text) : null;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? now : (currentStartDate ?? now),
      firstDate: isStartDate ? DateTime(2000) : (currentStartDate ?? DateTime(2000)),
      lastDate: isStartDate ? DateTime(2101) : DateTime(2101),
    );

    if (picked != null) {
      if (isStartDate) {
        if (currentEndDate != null && picked.isAfter(currentEndDate)) {
          endDateController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('End date cleared as it was before new start date')),
          );
        }
        startDateController.text = picked.toString().split(' ')[0];
      } else {
        if (currentStartDate != null && picked.isBefore(currentStartDate)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('End date cannot be before start date')),
          );
          return;
        }
        endDateController.text = picked.toString().split(' ')[0];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContainerWidget(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navigation Header
              NavigationPathWidget(
                mainTitle: widget.expanseId != null ? 'Edit Expense' : 'Add Expense',
                firstTitle: 'Expense',
                secondTitle: widget.expanseId != null ? 'Edit Expense' : 'Add Expense',
                secondTitleColor: AppColors.primary,
              ),
              const Gap(30),

              // Expense Title
              AppTextFormField(
                controller: titleController,
                title: 'Expense Title*',
                maxWidth: 440,
                validator: (value) => value!.isEmpty ? 'Please enter expense title' : null,
              ),
              const Gap(20),

              // Date Pickers
              Row(
                children: [
                  AppTextFormField(
                    controller: startDateController,
                    readOnly: true,
                    maxWidth: 210,
                    title: 'Start Date*',
                    onTap: () => _selectDate(context, startDateController),
                    validator: (value) => value!.isEmpty ? 'Please select start date' : null,
                  ),
                  const Gap(20),
                  AppTextFormField(
                    controller: endDateController,
                    readOnly: true,
                    maxWidth: 210,
                    title: 'End Date*',
                    onTap: () => _selectDate(context, endDateController),
                    validator: (value) => value!.isEmpty ? 'Please select end date' : null,
                  ),
                ],
              ),
              const Gap(20),

              // Expense Items Section
              Text('Expense Items', style: Theme.of(context).textTheme.titleMedium),
              const Gap(10),

              ValueListenableBuilder<List<ExpenseItemModel>>(
                valueListenable: expenseItems,
                builder: (context, items, _) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            // Expense Name
                            AppTextFormField(
                              controller: item.nameController,
                              maxWidth: 270,
                              title: 'Expense Name*',
                              validator: (value) => value!.isEmpty ? 'Enter expense name' : null,
                            ),
                            const Gap(20),

                            // Expense Price
                            AppTextFormField(
                              controller: item.priceController,
                              title: 'Price*',
                              maxWidth: 150,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) => updateTotalExpense(),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Enter price';
                                final price = double.tryParse(value);
                                if (price == null || price < 0) return 'Enter valid price';
                                return null;
                              },
                            ),

                            // Remove Item Button
                            if (index > 0)
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () {
                                  expenseItems.value = List.from(expenseItems.value)..removeAt(index);
                                  updateTotalExpense();
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),

              // Add More Items Button
              TextButton.icon(
                onPressed: () {
                  expenseItems.value = [
                    ...expenseItems.value,
                    ExpenseItemModel(
                      nameController: TextEditingController(),
                      priceController: TextEditingController(),
                    ),
                  ];
                },
                icon: const Icon(Icons.add),
                label: const Text('Add More Items'),
              ),

              const Gap(20),

              // Total Expense Display
              ValueListenableBuilder<double>(
                valueListenable: totalExpense,
                builder: (context, value, _) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    width: 440,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Expense:'),
                        Text(
                          '₹${value.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Gap(20),

              // Submit Button
              ValueListenableBuilder<bool>(
                valueListenable: isButtonLoading,
                builder: (context, loading, _) {
                  return CustomeButtonGradiantWidget(
                    onTap: () {
                      if (!loading) {
                        EasyDebounce.debounce(
                          'edit-create-user',
                          const Duration(milliseconds: 500),
                          () {
                            if (widget.expanseId != null) {
                              updateExpense();
                            } else {
                              log('create __________________');
                              createExpense();
                            }
                          },
                        );
                      }
                    },
                    height: 38,
                    width: 100,
                    isGradient: true,
                    isLoading: loading,
                    child: Text(
                      widget.expanseId != null ? 'Edit' : 'Create',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 15, color: AppColors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createExpense() async {
    // if (_formKey.currentState!.validate()) {
    log('message 11111111111111111');
    isButtonLoading.value = true;
    final response = await getIt<IExpenseRepository>().addExpense(
      expenseName: titleController.text,
      startDate: DateTime.parse(startDateController.text),
      endDate: DateTime.parse(endDateController.text),
      totalExpense: totalExpense.value,
      expenseItems: expenseItems.value,
    );

    response.fold(
      (l) {
        isButtonLoading.value = false;
        log('error');
        Utility.toast(message: l.message);
      },
      (r) {
        log('upto date');

        isButtonLoading.value = false;
        Utility.toast(message: 'Expense created successfully');
        context.read<RefreshCubit>().modifyExpanse(r, ExpanseAction.add);
        context.pop();
      },
    );
    // }
  }

  Future<void> updateExpense() async {
    if (_formKey.currentState!.validate()) {
      isButtonLoading.value = true;
      final response = await getIt<IExpenseRepository>().updateExpense(
        expenseId: widget.expanseId!,
        expenseName: titleController.text,
        startDate: DateTime.parse(startDateController.text),
        endDate: DateTime.parse(endDateController.text),
        totalExpense: totalExpense.value,
        expenseItems: expenseItems.value,
      );

      response.fold(
        (l) {
          isButtonLoading.value = false;
          Utility.toast(message: l.message);
        },
        (r) {
          isButtonLoading.value = false;
          Utility.toast(message: 'Expense updated successfully');
          context.read<RefreshCubit>().modifyExpanse(r, ExpanseAction.edit);
          context.pop();
        },
      );
    }
  }
}
