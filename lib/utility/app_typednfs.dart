import 'package:admin_kdv/utility/failure/custom_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

typedef RouteTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
);
typedef FireStoreCollectionRefrence = CollectionReference<Map<String, dynamic>>;
typedef EitherResult<T> = Either<CustomFailure, T>;
typedef FirebaseResult<T> = Future<EitherResult<T>>;
