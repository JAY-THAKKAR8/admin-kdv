import 'package:admin_kdv/utility/app_typednfs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension FirestoreExtentionsX on FirebaseFirestore {
  FireStoreCollectionRefrence get users => collection('users');
  FireStoreCollectionRefrence get expenses => collection('expenses');
  FireStoreCollectionRefrence get maintenance => collection('maintenance');
}
