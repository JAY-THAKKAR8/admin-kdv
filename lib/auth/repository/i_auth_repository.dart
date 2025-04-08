import 'dart:io';

import 'package:admin_kdv/utility/app_typednfs.dart';
import 'package:admin_kdv/utility/failure/custom_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

part 'auth_repository.dart';

abstract class IAuthRepository {
  IAuthRepository(this.firebaseAuth, this.firebaseFirestore);
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  FirebaseResult<User> signInWithEmail({
    required String email,
    required String password,
  });

  FirebaseResult<String> logout();

  FirebaseResult<String> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  FirebaseResult<User> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      String? villNumber,
      String? mobileNumber,
      String? line,
      String? role});
}
