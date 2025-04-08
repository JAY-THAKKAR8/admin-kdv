import 'dart:developer';

import 'package:admin_kdv/expenses/model/expense_item_model.dart';
import 'package:admin_kdv/expenses/model/expense_model.dart';
import 'package:admin_kdv/expenses/repository/i_expense_repository.dart';
import 'package:admin_kdv/extentions/firestore_extentions.dart';
import 'package:admin_kdv/utility/app_typednfs.dart';
import 'package:admin_kdv/utility/failure/custom_failure.dart';
import 'package:admin_kdv/utility/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IExpenseRepository)
class ExpenseRepository extends IExpenseRepository {
  ExpenseRepository(super.firestore);

  @override
  FirebaseResult<ExpenseModel> addExpense({
    required String expenseName,
    required DateTime startDate,
    required DateTime endDate,
    required double totalExpense,
    required List<ExpenseItemModel> expenseItems,
  }) {
    
    return Result<ExpenseModel>().tryCatch(
      run: () async {
        final now = Timestamp.now();
        final expenseCollection = FirebaseFirestore.instance.expenses;
        final expenseDoc = expenseCollection.doc();
        List<Map<String, dynamic>> itemDataList = [];
        List<ExpenseItemModel> addedItem = [];    
        for (var item in expenseItems){
          final itemData = {
               'item_name' : item.nameController.text.trim(),
               'item_price': item.priceController.text.trim()
          };
          itemDataList.add(itemData);
          addedItem.add(item);
        }

        await expenseDoc.set({
          'id': expenseDoc.id,  
          'expense_name': expenseName,
          'start_date': startDate,
          'end_date': endDate,
          'total_expense': totalExpense.toString(),
          'expense_items': itemDataList ,
          'created_at': now.toDate(),
          'updated_at': now.toDate(),
        });

        return ExpenseModel(
          id: expenseDoc.id,
          expenseName: expenseName,
          startDate: startDate,
          endDate: endDate,
          totalExpense: totalExpense.toString(),
          expenseItems: addedItem,
        );
      },
    );
  }
  
  @override
  FirebaseResult<ExpenseModel> updateExpense({
    required String expenseId,
    String? expenseName,
    DateTime? startDate,
    DateTime? endDate,
    double? totalExpense,
    List<ExpenseItemModel>? expenseItems,
  }) {
    return Result<ExpenseModel>().tryCatch(
      run: () async {
        if (expenseId.isEmpty) {
          throw const CustomFailure(message: 'Expense ID cannot be empty');
        }

        final now = Timestamp.now();
        final expenseCollection = FirebaseFirestore.instance.expenses;
        final expenseDoc = expenseCollection.doc(expenseId);
        
        List<Map<String, dynamic>> itemDataList = [];
        List<ExpenseItemModel> addedItem = [];    
        for (var item in expenseItems ?? []){
          final itemData = {
               'item_name' : item.nameController.text.trim(),
               'item_price': item.priceController.text.trim()
          };
          itemDataList.add(itemData);
          addedItem.add(item);
        }

        await expenseDoc.update({
          'id': expenseDoc.id,  
          'expense_name': expenseName,
          'start_date': startDate,
          'end_date': endDate,
          'total_expense': totalExpense.toString(),
          'expense_items': itemDataList ,
          'created_at': now.toDate(),
          'updated_at': now.toDate(),
        });

        final updatedDoc = await expenseDoc.get();
        if (!updatedDoc.exists) {
          throw const CustomFailure(message: 'Failed to retrieve updated expense');
        }

        return ExpenseModel.fromJson(updatedDoc.data()!);
      },
    );
  }

  @override
  FirebaseResult<void> deleteExpense({required String expenseId}) {
    return Result<void>().tryCatch(
      run: () async {
        final expenseCollection = FirebaseFirestore.instance.expenses;
        await expenseCollection.doc(expenseId).delete();
      },
    );
  }

  @override
  FirebaseResult<List<ExpenseModel>> getAllExpenses() {
    return Result<List<ExpenseModel>>().tryCatch(
      run: () async {
        final expenses = await FirebaseFirestore.instance.expenses.get();
        final expenseModels = expenses.docs.map((e) => ExpenseModel.fromJson(e.data())).toList();
         log(expenseModels.length.toString() + "length of ex");
        return expenseModels;
      },
    );
  }

  @override
  FirebaseResult<ExpenseModel> getExpense({required String expenseId}) {
    return Result<ExpenseModel>().tryCatch(
      run: () async {
        final expenseCollection = FirebaseFirestore.instance.expenses;
        final expenseDoc = await expenseCollection.doc(expenseId).get();

        if (!expenseDoc.exists) {
          throw Exception('Expense not found');
        }

        return ExpenseModel.fromJson(expenseDoc.data()!);
      },
    );
  }

}
