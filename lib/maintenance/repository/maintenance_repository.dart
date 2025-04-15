import 'dart:developer';

import 'package:admin_kdv/extentions/firestore_extentions.dart';
import 'package:admin_kdv/maintenance/model/maintenance_model.dart';
import 'package:admin_kdv/maintenance/repository/i_maintenance_repository.dart';
import 'package:admin_kdv/utility/app_typednfs.dart';
import 'package:admin_kdv/utility/failure/custom_failure.dart';
import 'package:admin_kdv/utility/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IMaintenanceRepository)
class MaintenanceRepository extends IMaintenanceRepository {
  MaintenanceRepository(super.firestore);

  @override
  FirebaseResult<MaintenanceModel> addMaintenance({
    required String userId,
    required String userName,
    required String lineNumber,
    required String description,
    required double amount,
    required DateTime date,
    required String addedBy,
    required String addedById,
  }) {
    return Result<MaintenanceModel>().tryCatch(
      run: () async {
        final now = Timestamp.now();
        final maintenanceCollection = FirebaseFirestore.instance.maintenance;
        final maintenanceDoc = maintenanceCollection.doc();

        await maintenanceDoc.set({
          'id': maintenanceDoc.id,
          'user_id': userId,
          'user_name': userName,
          'line_number': lineNumber,
          'description': description,
          'amount': amount.toString(),
          'date': date,
          'added_by': addedBy,
          'added_by_id': addedById,
          'created_at': now.toDate(),
          'updated_at': now.toDate(),
        });

        return MaintenanceModel(
          id: maintenanceDoc.id,
          userId: userId,
          userName: userName,
          lineNumber: lineNumber,
          description: description,
          amount: amount,
          date: date,
          addedBy: addedBy,
          addedById: addedById,
          createdAt: now.toDate(),
          updatedAt: now.toDate(),
        );
      },
    );
  }

  @override
  FirebaseResult<MaintenanceModel> updateMaintenance({
    required String maintenanceId,
    String? userId,
    String? userName,
    String? lineNumber,
    String? description,
    double? amount,
    DateTime? date,
  }) {
    return Result<MaintenanceModel>().tryCatch(
      run: () async {
        if (maintenanceId.isEmpty) {
          throw const CustomFailure(message: 'Maintenance ID cannot be empty');
        }

        final now = Timestamp.now();
        final maintenanceCollection = FirebaseFirestore.instance.maintenance;
        final maintenanceDoc = maintenanceCollection.doc(maintenanceId);
        final maintenanceSnapshot = await maintenanceDoc.get();

        if (!maintenanceSnapshot.exists) {
          throw const CustomFailure(message: 'Maintenance not found');
        }

        final data = maintenanceSnapshot.data() as Map<String, dynamic>;
        final Map<String, dynamic> updateData = {
          'updated_at': now.toDate(),
        };

        if (userId != null) updateData['user_id'] = userId;
        if (userName != null) updateData['user_name'] = userName;
        if (lineNumber != null) updateData['line_number'] = lineNumber;
        if (description != null) updateData['description'] = description;
        if (amount != null) updateData['amount'] = amount.toString();
        if (date != null) updateData['date'] = date;

        await maintenanceDoc.update(updateData);

        // Get the updated document
        final updatedDoc = await maintenanceDoc.get();
        return MaintenanceModel.fromFirestore(updatedDoc);
      },
    );
  }

  @override
  FirebaseResult<List<MaintenanceModel>> getAllMaintenance() {
    return Result<List<MaintenanceModel>>().tryCatch(
      run: () async {
        final maintenance = await FirebaseFirestore.instance.maintenance.get();
        final maintenanceModels = maintenance.docs.map((e) => MaintenanceModel.fromFirestore(e)).toList();
        log(maintenanceModels.length.toString() + " length of maintenance");
        return maintenanceModels;
      },
    );
  }

  @override
  FirebaseResult<MaintenanceModel> getMaintenance({required String maintenanceId}) {
    return Result<MaintenanceModel>().tryCatch(
      run: () async {
        final maintenanceCollection = FirebaseFirestore.instance.maintenance;
        final maintenanceDoc = await maintenanceCollection.doc(maintenanceId).get();

        if (!maintenanceDoc.exists) {
          throw Exception('Maintenance not found');
        }

        return MaintenanceModel.fromFirestore(maintenanceDoc);
      },
    );
  }

  @override
  FirebaseResult<void> deleteMaintenance({required String maintenanceId}) {
    return Result<void>().tryCatch(
      run: () async {
        final maintenanceCollection = FirebaseFirestore.instance.maintenance;
        await maintenanceCollection.doc(maintenanceId).delete();
      },
    );
  }

  @override
  FirebaseResult<List<MaintenanceModel>> getMaintenanceByMonth({
    required int month,
    required int year,
  }) {
    return Result<List<MaintenanceModel>>().tryCatch(
      run: () async {
        final startDate = DateTime(year, month, 1);
        final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

        final maintenance = await FirebaseFirestore.instance.maintenance
            .where('date', isGreaterThanOrEqualTo: startDate)
            .where('date', isLessThanOrEqualTo: endDate)
            .get();

        final maintenanceModels = maintenance.docs.map((e) => MaintenanceModel.fromFirestore(e)).toList();
        return maintenanceModels;
      },
    );
  }

  @override
  FirebaseResult<List<MaintenanceModel>> getMaintenanceByLine({required String lineNumber}) {
    return Result<List<MaintenanceModel>>().tryCatch(
      run: () async {
        final maintenance = await FirebaseFirestore.instance.maintenance
            .where('line_number', isEqualTo: lineNumber)
            .get();

        final maintenanceModels = maintenance.docs.map((e) => MaintenanceModel.fromFirestore(e)).toList();
        return maintenanceModels;
      },
    );
  }

  @override
  FirebaseResult<List<MaintenanceModel>> getMaintenanceByLineAndMonth({
    required String lineNumber,
    required int month,
    required int year,
  }) {
    return Result<List<MaintenanceModel>>().tryCatch(
      run: () async {
        final startDate = DateTime(year, month, 1);
        final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

        final maintenance = await FirebaseFirestore.instance.maintenance
            .where('line_number', isEqualTo: lineNumber)
            .where('date', isGreaterThanOrEqualTo: startDate)
            .where('date', isLessThanOrEqualTo: endDate)
            .get();

        final maintenanceModels = maintenance.docs.map((e) => MaintenanceModel.fromFirestore(e)).toList();
        return maintenanceModels;
      },
    );
  }
}
