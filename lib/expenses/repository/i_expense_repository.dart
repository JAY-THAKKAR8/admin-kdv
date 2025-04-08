import 'package:admin_kdv/expenses/model/expense_item_model.dart';
import 'package:admin_kdv/expenses/model/expense_model.dart';
import 'package:admin_kdv/utility/app_typednfs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IExpenseRepository {
  final FirebaseFirestore firestore;
  IExpenseRepository(this.firestore);

  FirebaseResult<List<ExpenseModel>> getAllExpenses();

  FirebaseResult<ExpenseModel> addExpense({
    required String expenseName,
    required DateTime startDate,
    required DateTime endDate,
    required double totalExpense,
    required List<ExpenseItemModel> expenseItems,
  });

  FirebaseResult<ExpenseModel> updateExpense({
    required String expenseId,
    String? expenseName,
    DateTime? startDate,
    DateTime? endDate,
    double? totalExpense,
    List<ExpenseItemModel>? expenseItems,
  });

  FirebaseResult<ExpenseModel> getExpense({
    required String expenseId,
  });

  FirebaseResult<void> deleteExpense({
    required String expenseId,
  });
}
