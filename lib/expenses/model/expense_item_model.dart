// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ExpenseItemModel extends Equatable {
  const ExpenseItemModel({
    required this.nameController,
    required this.priceController,
  });

  factory ExpenseItemModel.fromJson(Map<String, dynamic> json) {
    return ExpenseItemModel(
      nameController: TextEditingController(text: json['item_name'] as String? ?? ''),
      priceController: TextEditingController(text: (json['item_price'] as String?)?.toString() ?? ''),
    );
  }

  final TextEditingController nameController;
  final TextEditingController priceController;

  Map<String, dynamic> toJson() {
    return {
      'item_name': nameController.text,
      'item_price': double.tryParse(priceController.text) ?? 0.0,
    };
  }

  ExpenseItemModel copyWith({
    TextEditingController? nameController,
    TextEditingController? priceController,
  }) {
    return ExpenseItemModel(
        nameController: nameController ?? this.nameController,
        priceController: priceController ?? this.priceController);
  }

  @override
  List<Object?> get props => [nameController, priceController];
}
