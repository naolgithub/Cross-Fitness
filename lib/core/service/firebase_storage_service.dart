import 'dart:developer';
import 'dart:io';

import 'package:cross_fitness/core/service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  FirebaseStorage storage = FirebaseStorage.instance;
  static Future<void> listExample() async {
    ListResult result = await FirebaseStorage.instance.ref().listAll();
    for (var element in result.items) {
      log(element.name);
    }
  }

  static Future<bool> uploadImage({required String filePath}) async {
    File file = File(filePath);
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        TaskSnapshot upload = await FirebaseStorage.instance
            .ref('user_logos/${user.uid}.png')
            .putFile(file);
        String downloadUrl = await upload.ref.getDownloadURL();
        await UserService.editPhoto(downloadUrl);
        return true;
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
