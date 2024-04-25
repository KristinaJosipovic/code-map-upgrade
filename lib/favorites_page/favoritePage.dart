import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:code_map/search_screen/language_names.dart';
import 'package:code_map/home_page.dart';

import '../articles/article_page.dart';
import '../login.dart';

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
        print('No matching documents found');
        return;
      }
    } catch (e) {
      print('Error retrieving data: $e');
      return;
    }
  }

  void _getNamesFromFirestore() async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('Tehnologije');
    QuerySnapshot querySnapshot = await collectionReference.get();

    querySnapshot.docs.forEach((doc) {
      if (userFavourites.contains(doc['naziv'])) {
        tempList.add(Names.fromFirestore(doc));
      }
    });

    setState(() {
      namesList = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLogin ? const NotLoggedInScreen() :
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
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
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
            childAspectRatio: 0.8,
          ),
          itemCount: namesList.length,
          itemBuilder: (context, index) {
            final tech = namesList[index];
            return GestureDetector(
              onTap: () { // TODO: to be implemented
                print([tech.name, tech.imageUrl]);
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    MainArticle(currentTech: tech.name, imageUrl: tech.imageUrl,)),
              );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Color(0xae000000),
                    width: 4,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0,3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 110, // Širina slike
                      height: 110, // Visina slike
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          tech.imageUrl,
                          //fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tech.name,
                      style: const TextStyle(
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotLoggedInScreen extends StatelessWidget {
  const NotLoggedInScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Za korištenje ove opcije morate biti prijavljeni!\n\nŽelite li se prijaviti?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins-Medium',
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogIn()),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  "Prijavite se",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins-Medium',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
