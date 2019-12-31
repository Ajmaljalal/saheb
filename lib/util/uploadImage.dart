import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

Future uploadImage({File image, String collection}) async {
  if (image != null) {
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        '$collection/${Path.basename('${image.path} ${DateTime.now().toString()}')}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    final fileURL = await storageReference.getDownloadURL();
    return fileURL;
  }
}
