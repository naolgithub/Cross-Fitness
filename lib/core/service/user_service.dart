import 'dart:developer';

import 'package:cross_fitness/core/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final FirebaseAuth firebase = FirebaseAuth.instance;

  static Future<bool> editPhoto(String photoUrl) async {
    try {
      await firebase.currentUser?.updatePhotoURL(photoUrl);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> changeUserData(
      {required String displayName, required String email}) async {
    try {
      await firebase.currentUser?.updateDisplayName(displayName);
      await firebase.currentUser?.updateEmail(email);
      // await firebase.currentUser!.verifyBeforeUpdateEmail(email);
      return true;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static Future<bool> changePassword({required String newPass}) async {
    try {
      await firebase.currentUser?.updatePassword(newPass);
      return true;
    } on FirebaseAuthException catch (e) {
      // throw CustomFirebaseException(getExceptionMessage(e));
      throw Exception(getExceptionMessage(e));
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> signOut() async {
    await firebase.signOut();
  }
}
