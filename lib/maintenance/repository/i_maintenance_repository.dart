import 'package:admin_kdv/maintenance/model/maintenance_model.dart';
import 'package:admin_kdv/utility/app_typednfs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IMaintenanceRepository {
  final FirebaseFirestore firestore;
  IMaintenanceRepository(this.firestore);

  FirebaseResult<List<MaintenanceModel>> getAllMaintenance();
  
  FirebaseResult<List<MaintenanceModel>> getMaintenanceByMonth({
    required int month,
    required int year,
  });
  
  FirebaseResult<List<MaintenanceModel>> getMaintenanceByLine({
    required String lineNumber,
  });
  
  FirebaseResult<List<MaintenanceModel>> getMaintenanceByLineAndMonth({
    required String lineNumber,
    required int month,
    required int year,
  });

  FirebaseResult<MaintenanceModel> addMaintenance({
    required String userId,
    required String userName,
    required String lineNumber,
    required String description,
    required double amount,
    required DateTime date,
    required String addedBy,
    required String addedById,
  });

  FirebaseResult<MaintenanceModel> updateMaintenance({
    required String maintenanceId,
    String? userId,
    String? userName,
    String? lineNumber,
    String? description,
    double? amount,
    DateTime? date,
  });

  FirebaseResult<MaintenanceModel> getMaintenance({
    required String maintenanceId,
  });

  FirebaseResult<void> deleteMaintenance({
    required String maintenanceId,
  });
}
