import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_map/screens/article_screen.dart';
import 'package:code_map/user_authentication/not_logged_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:code_map/screens/search_screen/language_names.dart';
import 'package:code_map/screens/home_screen.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late List<Names> namesList = [];
  late List<Names> tempList = [];
  List<String> userFavourites = [];
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkIfLogin();
    Future.delayed(Duration.zero, () async {
      await _getUserFavourites(FirebaseAuth.instance.currentUser!.uid);
      _getNamesFromFirestore();
    });

  }

  Future<void> _getUserFavourites(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('Korisnici')
          .where('uid', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            querySnapshot.docs.first;
        Map<String, dynamic> data = docSnapshot.data()!;
        List<String> arrayData = List<String>.from(data['favourites'] ?? []);
        setState(() {
          userFavourites = arrayData;
        });
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  void _getNamesFromFirestore() async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('Tehnologije');
    QuerySnapshot querySnapshot = await collectionReference.get();

    for (var doc in querySnapshot.docs) {
      if (userFavourites.contains(doc['naziv'])) {
        tempList.add(Names.fromFirestore(doc));
      }
    }

    setState(() {
      namesList = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLogin ? Scaffold(
      appBar: AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.green],
          ),
        ),
      ),
      title: const Text(
        "Code <map>",
        style: TextStyle(
          fontFamily: 'Poppins-Medium',
          color: Colors.black,
          fontSize: 23,
        ),
      ),
    ), body: const NotLoggedInScreen(color: '0xff43bf6c',),) :
    Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.green],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()), (route) => false
            );
          },
        ),
        title: const Text(
          'Omiljeni',
          style: TextStyle(
            fontFamily: 'Poppins-Medium',
            color: Colors.black,
            fontSize: 23,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 20),
        child: ListView.builder(
          itemCount: namesList.length,
          itemBuilder: (context, index) {
            final tech = namesList[index];
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color(0xae000000),
                    width: 2,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainArticle(currentTech: tech.name, imageUrl: tech.imageUrl)),
                    );
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            child: Image.asset(
                              tech.imageUrl,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        tech.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins-Medium',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          FirebaseFirestore.instance.collection("Korisnici")
                              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            var docRef = querySnapshot.docs.first.reference;
                            docRef.update({
                              'favourites': FieldValue.arrayRemove([tech.name])
                            })
                                .then((_) {
                              setState(() {
                                namesList.removeAt(index);
                              });
                            })
                                .catchError((error){});
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

