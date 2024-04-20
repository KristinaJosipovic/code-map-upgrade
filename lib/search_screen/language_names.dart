import 'package:cloud_firestore/cloud_firestore.dart';

class Names {
  final String name;
  final String imageUrl;

  Names({required this.name, required this.imageUrl});

  factory Names.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Names(
      name: data['naziv'] ?? '',
      imageUrl: data['slika'] ?? '',
    );
  }
}
