part of 'i_auth_repository.dart';

@Injectable(as: IAuthRepository)
class AuthRepository extends IAuthRepository {
  AuthRepository(super.firebaseAuth, super.firebaseFirestore);

  @override
  FirebaseResult<User> signInWithEmail({required String email, required String password}) async {
    try {
      final credentails = await firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());

      if (credentails.user == null) {
        return left(FirebaseFailure('User Not Found'));
      }

      return right(credentails.user!);
    } on FirebaseAuthException catch (e) {
      return left(FirebaseFailure(e));
    } on FirebaseException catch (e) {
      return left(FirebaseFailure(e));
    } on SocketException {
      return left(SocketFailure());
    } catch (e) {
      return left(CustomFailure(message: e.toString()));
    }
  }

  @override
  FirebaseResult<String> logout() async {
    try {
      await firebaseAuth.signOut();

      return right('Logout Successfully');
    } on FirebaseAuthException catch (e) {
      return left(FirebaseFailure(e));
    } on FirebaseException catch (e) {
      return left(FirebaseFailure(e));
    } on SocketException {
      return left(SocketFailure());
    } catch (e) {
      return left(CustomFailure(message: e.toString()));
    }
  }

  @override
  FirebaseResult<String> changePassword({required String oldPassword, required String newPassword}) async {
    try {
      final firebaseUser = firebaseAuth.currentUser;

      final oldCredential = EmailAuthProvider.credential(
        email: firebaseUser!.email!,
        password: oldPassword,
      );

      await firebaseUser.reauthenticateWithCredential(oldCredential);
      await firebaseUser.updatePassword(newPassword);
      return right('Password changed successfully');
    } on FirebaseAuthException catch (e) {
      return left(FirebaseFailure(e));
    } on FirebaseException catch (e) {
      return left(FirebaseFailure(e));
    } on SocketException {
      return left(SocketFailure());
    } catch (e) {
      return left(CustomFailure(message: e.toString()));
    }
  }

  @override
  FirebaseResult<User> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      String? villNumber,
      String? mobileNumber,
      String? line,
      String? role}) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (userCredential.user == null) {
        return left(FirebaseFailure('User creation failed'));
      }

      final now = Timestamp.now();
      await firebaseFirestore.collection('users').doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'villa_number': villNumber,
        'name': name,
        'email': email,
        'line_number': line,
        'role': role,
        'mobile_number': mobileNumber,
        'is_villa_open': '1',
        'createdAt': now.toDate(),
        'updatedAt': now.toDate(),
      });

      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return left(FirebaseFailure(e));
    } on FirebaseException catch (e) {
      return left(FirebaseFailure(e));
    } on SocketException {
      return left(SocketFailure());
    } catch (e) {
      return left(CustomFailure(message: e.toString()));
    }
  }
}
