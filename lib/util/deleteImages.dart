import 'package:firebase_storage/firebase_storage.dart';

Future deleteImagesFromDB({
  List images,
  String collection,
}) async {
  if (images != null || images.length != 0) {
    var tempList = images.toSet().toList(); // to remove duplicates if any
    FirebaseStorage storage = FirebaseStorage.instance;
    for (var i = 0; i < tempList.length; i++) {
      StorageReference ref = await storage.getReferenceFromUrl(tempList[i]);
      try {
        await ref.delete();
      } catch (error) {
        continue;
      }
    }
  }
}
