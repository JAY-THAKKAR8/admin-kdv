// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MaintenanceModel extends Equatable {
  final String? id;
  final String? userId;
  final String? userName;
  final String? lineNumber;
  final String? description;
  final double? amount;
  final DateTime? date;
  final String? addedBy;
  final String? addedById;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DocumentSnapshot? documentSnapshot;

  const MaintenanceModel({
    this.id,
    this.userId,
    this.userName,
    this.lineNumber,
    this.description,
    this.amount,
    this.date,
    this.addedBy,
    this.addedById,
    this.createdAt,
    this.updatedAt,
    this.documentSnapshot,
  });

  MaintenanceModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? lineNumber,
    String? description,
    double? amount,
    DateTime? date,
    String? addedBy,
    String? addedById,
    DateTime? createdAt,
    DateTime? updatedAt,
    DocumentSnapshot? documentSnapshot,
  }) {
    return MaintenanceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      lineNumber: lineNumber ?? this.lineNumber,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      addedBy: addedBy ?? this.addedBy,
      addedById: addedById ?? this.addedById,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      documentSnapshot: documentSnapshot ?? this.documentSnapshot,
    );
  }

  factory MaintenanceModel.empty() => const MaintenanceModel();

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      userName: json['user_name'] as String?,
      lineNumber: json['line_number'] as String?,
      description: json['description'] as String?,
      amount: json['amount'] != null ? double.parse(json['amount'].toString()) : null,
      date: (json['date'] as Timestamp?)?.toDate(),
      addedBy: json['added_by'] as String?,
      addedById: json['added_by_id'] as String?,
      createdAt: (json['created_at'] as Timestamp?)?.toDate(),
      updatedAt: (json['updated_at'] as Timestamp?)?.toDate(),
    );
  }

  factory MaintenanceModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return MaintenanceModel.fromJson(doc.data()!).copyWith(
      id: doc.id,
      documentSnapshot: doc,
    );
  }

  @override
  String toString() {
    return 'MaintenanceModel(id: $id, userId: $userId, userName: $userName, lineNumber: $lineNumber, description: $description, amount: $amount, date: $date, addedBy: $addedBy, addedById: $addedById)';
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        lineNumber,
        description,
        amount,
        date,
        addedBy,
        addedById,
        createdAt,
        updatedAt,
        documentSnapshot,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'line_number': lineNumber,
      'description': description,
      'amount': amount,
      'date': date?.toIso8601String(),
      'added_by': addedBy,
      'added_by_id': addedById,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
