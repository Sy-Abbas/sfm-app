import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'dart:developer' as devetools show log;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);
    try {
      await storage.ref(fileName).putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      devetools.log(e.toString());
    }
  }

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results = await storage.ref('test').listAll();

    results.items.forEach((firebase_storage.Reference ref) {
      devetools.log(ref.toString());
    });
    return results;
  }

  Future<String> downloadURL(String imageName) async {
    String downloadURL = await storage.ref(imageName).getDownloadURL();
    return downloadURL;
  }
}
