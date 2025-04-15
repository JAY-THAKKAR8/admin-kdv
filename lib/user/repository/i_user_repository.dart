import 'package:admin_kdv/user/model/user_model.dart';
import 'package:admin_kdv/utility/app_typednfs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IUserRepository {
  final FirebaseFirestore firestore;
  IUserRepository(this.firestore);

  FirebaseResult<List<UserModel>> getAllUsers();

  FirebaseResult<UserModel> addCustomer({
    String? name,
    String? email,
    String? mobileNumber,
    String? villNumber,
    String? line,
    String? role,
    String? password,
  });

  FirebaseResult<UserModel> updateCustomer({
    required String userId,
    String? name,
    String? mobileNumber,
    String? line,
    String? role,
    String? villNumber,
    String? isVillaOpen,
  });

  FirebaseResult<UserModel> getUser({
    required String userId,
  });

  FirebaseResult<void> deleteCustomer({
    required String userId,
  });

  FirebaseResult<UserModel> getCurrentUser();
}
