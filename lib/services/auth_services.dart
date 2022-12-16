import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notester/model/auth_user.dart';
import 'package:notester/services/auth_exceptions.dart';
import 'package:notester/services/cloud/cloud_note.dart';
import 'package:notester/services/cloud/cloud_storage_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final _firebaseAuth = FirebaseAuth.instance;
  final users = FirebaseFirestore.instance.collection('users');

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  Future<AuthUser> signUp(
      {required String email, required String password, required String fullName, String? phoneNumber}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      updateUserName(fullName: fullName, phone: phoneNumber);
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailInUseAuthException();
      } else if (e.code == 'operation-not-allowed') {
        throw OperationNotAllowedException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      // throw Exception(e.toString());
      throw GenericAuthException();
    }
  }

  updateUserName({required String fullName, String? phone, String? address}) async {
    User? user = _firebaseAuth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.userId = user.uid;
    userModel.name = fullName;
    userModel.profileImage = user.photoURL;
    userModel.createdDate = user.metadata.creationTime.toString();
    userModel.phone = phone;
    userModel.address = address;
    try {
      await users.doc(user.uid).set({
        fullNameFieldName: userModel.name,
        profileImageFieldName: userModel.profileImage ?? "",
        emailFieldName: userModel.email,
        ownerUserIdFieldName: userModel.userId,
        phoneFieldName: userModel.phone ?? "",
        addressFieldName: userModel.address ?? "",
        createdDateFieldName: userModel.createdDate ?? "",
        updatedDateFieldName: userModel.updatedDate ?? ""
      });
    } catch (e) {
      throw GenericAuthException();
    }
  }

  Future<AuthUser?> signIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
    return null;
  }

  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firebaseAuth.signOut();
        await googleSignIn.signOut();
      } else {
        throw UserNotLoggedInAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firebaseAuth.currentUser?.sendEmailVerification();
      } else {
        throw UserNotLoggedInAuthException();
      }
    } catch (e) {
      // throw Exception(e);
      throw GenericAuthException();
    }
  }

  Future<void> sendPasswordReset({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'firebase_auth/inavalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'firebase_auth/user-not-found') {
        throw UserNotFoundException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future<AuthUser?> googleLogIn() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential =
          GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final signInData = await _firebaseAuth.signInWithCredential(credential);
      log("SIGN IN DATA: $signInData");
      final user = currentUser;
      if (signInData.additionalUserInfo != null) {
        if (signInData.additionalUserInfo!.isNewUser) {
          updateUserName(fullName: signInData.user!.displayName!, phone: signInData.user!.phoneNumber ?? "");
        }
      }

      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } catch (e) {
      log("EXCEPTION: $e");
      throw GenericAuthException();
    }
  }
}
