import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future add (Map<String, dynamic> techInfoMap, String id) async{
    return await FirebaseFirestore.instance
        .collection("Tehnologije")
        .doc(id)
        .set(techInfoMap);
  }
}