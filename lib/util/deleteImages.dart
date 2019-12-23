import 'package:firebase_storage/firebase_storage.dart';
//import 'package:path/path.dart' as Path;
//import 'dart:io';

Future deleteImages({
  images,
  String collection,
}) async {
  if (images != null || images.lenght != 0) {
    FirebaseStorage storage = FirebaseStorage.instance;
    images.forEach((image) async {
      StorageReference ref = await storage.getReferenceFromUrl(image);
      await ref.delete();
    });
  }
}
