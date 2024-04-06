import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class DatabaseMethods {
  Future add (Map<String, dynamic> techInfoMap, String id) async{
    return await FirebaseFirestore.instance
        .collection("Tehnologije")
        .doc(id)
        .set(techInfoMap);
  }
}

Reference get firebaseStorage => FirebaseStorage.instance.ref();
class FirebaseStorageService extends GetxService {
  Future<String?> getImage(String? imgName) async {
    if (imgName == null) {
      return null;
    }
    try {
      var urlRef = firebaseStorage.child("Tehnologije").child(
          '${imgName.toLowerCase()}.png');
      var imgUrl = await urlRef.getDownloadURL();
      return imgUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
