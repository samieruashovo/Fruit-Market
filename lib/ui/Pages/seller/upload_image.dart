import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadImageToStorage(File file, String fileName) async {
  TaskSnapshot uploadTask = await FirebaseStorage.instance
      .ref(fileName)
      .putFile(
          file,
          SettableMetadata(customMetadata: {
            'product-name': 'Name',
            'product-price': '100'
          }));
  String downloadUrl = await uploadTask.ref.getDownloadURL();
  return downloadUrl;
}


