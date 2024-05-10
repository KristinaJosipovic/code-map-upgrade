import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_map/home_page.dart';
import 'package:code_map/bottom_navigation_bar.dart';
import 'package:code_map/webCompiler/webView.dart';
import 'package:firebase_auth/firebase_auth.dart';

const TextStyle tStyle = TextStyle(
  fontFamily: 'Poppins-Medium',
  color: Colors.black,
  fontSize: 14,
);

class MainArticle extends StatefulWidget {
  const MainArticle({Key? key, required this.currentTech, required this.imageUrl}) : super(key: key);
  final String currentTech;
  final String imageUrl;

  @override
  State<MainArticle> createState() => _MainArticleState();
}

class _MainArticleState extends State<MainArticle> {
  IconData favIcon = Icons.favorite_border;
  List<String> userFavourites = [];
  var isLogin = false;

  checkIfLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  Future<void> _getUserFavourites(String userId) async {
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
  }

  @override
  void initState() {
    super.initState();
    checkIfLogin();
    try {
      Future.delayed(Duration.zero, () async {
        await _getUserFavourites(FirebaseAuth.instance.currentUser!.uid);
        if (userFavourites.contains(widget.currentTech)) {
          setState(() {
            favIcon = Icons.favorite;
          });
        }
        else {
          favIcon = Icons.favorite_outline;
        }
      });
    }
    catch (e) {}
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Tekst').snapshots(),
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Dogodila se greška: ${snapshot.error}');
          } else {
            final technologiesText = snapshot.data?.docs.reversed.toList();
            for (var txt in technologiesText!) {
                if (txt['tech'] == widget.currentTech) {
                  try {
                    return DefaultTabController(
                        length: 2,
                      child: Scaffold(
                              appBar: AppBar(
                                flexibleSpace: Container(
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(txt['color'])),
                                  ),
                                ),
                                leading: IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const HomePage()),
                                    );
                                  },
                                ),
                                actions: [
                                  isLogin ?
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: IconButton(
                                      icon: Icon(favIcon, color: Colors.black),
                                      onPressed: () {
                                        print(FirebaseAuth.instance.currentUser?.uid);
                                        FirebaseFirestore.instance.collection("Korisnici")
                                            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                                            .get()
                                            .then((QuerySnapshot querySnapshot) {
                                              var docRef = querySnapshot.docs.first.reference;
                                              if (favIcon == Icons.favorite_outline) {
                                                setState(() {
                                                  favIcon = Icons.favorite;
                                                });
                                                docRef.update({
                                                'favourites': FieldValue.arrayUnion([txt['tech']])
                                              })
                                              .then((_) => {})
                                              .catchError((error) => {});
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                    backgroundColor: Colors.green,
                                                    content: Text(
                                                      "Dodano u omiljeno!",
                                                      style: TextStyle(fontSize: 16.0, fontFamily: 'Poppins-Medium',),
                                                    )));
                                              }
                                              else {
                                                setState(() {
                                                  favIcon = Icons.favorite_outline;
                                                });
                                                docRef.update({
                                                  'favourites': FieldValue.arrayRemove([txt['tech']])
                                                })
                                                    .then((_) => {})
                                                    .catchError((error) => {});
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                    duration: Duration(seconds: 2),
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                      "Uklonjeno iz omilienog!",
                                                      style: TextStyle(fontSize: 18.0, fontFamily: 'Poppins',),
                                                    )));
                                              }
                                        });
                                      },
                                    ),
                                  ) : Container(),
                                ],
                                title: Text(
                                  txt['tech'],
                                  style: const TextStyle(
                                    fontFamily: 'Poppins-Medium',
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                bottom: const TabBar(
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        'Tekst',
                                        style: tStyle,
                                      ),
                                    ),
                                    Tab(child: Text(
                                      'Kompajler',
                                      style: tStyle,
                                    ),),
                                  ],
                                ),
                              ),
                              body: TabBarView(
                              children: [
                                    SingleChildScrollView(
                                    padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                            textSection(txt, 'intro'),
                                            Image.asset(
                                            widget.imageUrl, width: 200, height: 200,),
                                              textSection(txt, 'history'),
                                              textSection(txt, 'interface'),
                                              textSection(txt, 'syntax'),
                                              textSection(txt, 'extensions'),
                                              textSection(txt, 'use'),
                                              textSection(txt, 'popularity'),
                                              textSection(txt, 'pros_cons'),
                                              textSection(txt, 'enumeration_des'),
                                              ListCard(txt, 'enumeration', 'color'),
                                              textSection(txt, 'implementation'),
                                              textSection(txt, 'enumeration_des2'),
                                              ListCard(txt, 'enumeration2', 'color'),
                                              ]
                                           )
                                      ),
                                WebViewCompiler(widget.currentTech, txt['color']),
                               ],
                              ),
                        bottomNavigationBar: const bottomNavigationBar(),
                             ),
                        );

                  }catch(e){}
                }}
            return const Text('Nema podataka za trenutnu tehnologiju');
           }
          },
    );
  }

  SingleChildScrollView ListCard(QueryDocumentSnapshot<Object?> txt, String textDoc, String color) {
    return SingleChildScrollView(
                                 child: Column(
                                   children: [
                                     ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: txt[textDoc].length ~/ 2,
                                            itemBuilder: (context, index) {
                                              final evenIndex = index * 2;
                                              final oddIndex = evenIndex + 1;
                                              try {
                                                return Card(
                                                  color: Color(
                                                      int.parse(txt[color])),
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(0.0),
                                                  ),
                                                  child: ExpansionTile(
                                                    title: Text(
                                                        txt[textDoc][evenIndex]
                                                            .replaceAll(
                                                            "\\n", "\n"),
                                                        style: const TextStyle(
                                                            fontFamily: 'Poppins',
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight
                                                                .w600
                                                        )
                                                    ),
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: Text(
                                                            txt[textDoc][oddIndex]
                                                                .replaceAll(
                                                                "\\n", "\n"),
                                                            style: tStyle,
                                                            textAlign: TextAlign.justify
                                                          ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                              catch (e) {}
                                              return null;
                                            },
                                          ),
                                   ],
                                 ),
                               );
  }

  SizedBox textSection(QueryDocumentSnapshot<Object?> txt, String textDoc) {
    return SizedBox(
      height: (txt[textDoc] != null && txt[textDoc].isNotEmpty)
          ? null : 0.0,
      child: Text((){
        try { return txt[textDoc].replaceAll("\\n", "\n").replaceAll("\\t", "\t");
        } catch (e) { return ''; }
        }(),
        style: tStyle,
        textAlign: TextAlign.justify,
      ),
    );
  }
}

