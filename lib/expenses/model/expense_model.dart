// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:admin_kdv/expenses/model/expense_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ExpenseModel extends Equatable {
  final String? id;
  final String? expenseName;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? totalExpense;
  final List<ExpenseItemModel> expenseItems;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DocumentSnapshot? documentSnapshot;

  const ExpenseModel(
      {this.id,
      this.expenseName,
      this.startDate,
      this.endDate,
      this.totalExpense,
      this.expenseItems = const [],
      this.createdAt,
      this.updatedAt,
      this.documentSnapshot});

  ExpenseModel copyWith({
    String? id,
    String? expenseName,
    DateTime? startDate,
    DateTime? endDate,
    String? totalExpense,
    List<ExpenseItemModel>? expenseItems,
    DateTime? createdAt,
    DateTime? updatedAt,
    DocumentSnapshot? documentSnapshot,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      expenseName: expenseName ?? this.expenseName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalExpense: totalExpense ?? this.totalExpense,
      expenseItems: expenseItems ?? this.expenseItems,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      documentSnapshot: documentSnapshot ?? this.documentSnapshot,
    );
  }

  factory ExpenseModel.empty() => const ExpenseModel();

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String?,
      expenseName: json['expense_name'] as String?,
      startDate: (json['start_date'] as Timestamp?)?.toDate(),
      endDate: (json['end_date'] as Timestamp?)?.toDate(),
      totalExpense: json['total_expense'] as String?,
      expenseItems: (json['expense_items'] as List?)
              ?.map((item) => ExpenseItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (json['created_at'] as Timestamp?)?.toDate(),
      updatedAt: (json['updated_at'] as Timestamp?)?.toDate(),
    );
  }

  factory ExpenseModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ExpenseModel.fromJson(doc.data()!).copyWith(
      id: doc.id,
      documentSnapshot: doc,
    );
  }

  @override
  String toString() {
    return 'ExpenseModel(id: $id, expenseName: $expenseName, startDate: $startDate, endDate: $endDate, totalExpense: $totalExpense, expenseItems: $expenseItems)';
  }

  @override
  List<Object?> get props => [
        id,
        expenseName,
        startDate,
        endDate,
        totalExpense,
        expenseItems,
        createdAt,
        updatedAt,
        documentSnapshot,
      ];

  @override
  bool operator ==(covariant ExpenseModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.expenseName == expenseName &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.totalExpense == totalExpense &&
        other.expenseItems == expenseItems &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.documentSnapshot == documentSnapshot;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        expenseName.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        totalExpense.hashCode ^
        expenseItems.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expense_name': expenseName,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'total_expense': totalExpense,
      'expense_items': expenseItems.map((item) => item.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
