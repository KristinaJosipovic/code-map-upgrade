import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:code_map/search_screen/language_names.dart';
import 'package:code_map/home_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late List<Names> namesList = [];
  late List<Names> tempList = [];

  @override
  void initState() {
    super.initState();
    _getNamesFromFirestore();
  }

  void _getNamesFromFirestore() async {
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('Tehnologije');
    QuerySnapshot querySnapshot = await collectionReference.get();

    querySnapshot.docs.forEach((doc) {
      tempList.add(Names.fromFirestore(doc));
    });

    setState(() {
      namesList = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {
              },
            ),
          ),
        ],
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
            return Container(
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
            );
          },
        ),
      ),
    );
  }
}
