import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_map/home_page.dart';
import 'package:code_map/side_menu.dart';

const TextStyle tStyle = TextStyle(
  fontFamily: 'Poppins',
  color: Colors.black,
  fontSize: 14,
);

class MainArticle extends StatefulWidget {
  const MainArticle({super.key});

  @override
  State<MainArticle> createState() => _MainArticleState();
}

class _MainArticleState extends State<MainArticle> {

  String currentTech = getCurrentTech();
  String urlImage = getUrlImage();
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
            for (var text in technologiesText!) {
                if (text['tech'] == currentTech) {
                  try {
                    return Scaffold(
                        drawer: const SideMenu(),
                        appBar: AppBar(
                          flexibleSpace: Container(
                            decoration: BoxDecoration(
                              color: Color(int.parse(text['color'])),
                            ),
                          ),
                          title:
                          Text(text['tech'], style: const TextStyle(
                              fontFamily: 'Poppins', color: Colors.black,
                              fontSize: 20, fontWeight: FontWeight.w600)),
                        ),
                        body: SingleChildScrollView(
                          padding: const EdgeInsets.all(12.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch, // bolje nego 'start'
                                  children: [
                                    textSection(text, 'intro'),
                                    Image.asset(
                                      urlImage, width: 200, height: 200,),
                                    textSection(text, 'history'),
                                    textSection(text, 'interface'),
                                    textSection(text, 'syntax'),
                                    textSection(text, 'extensions'),
                                    textSection(text, 'use'),
                                    textSection(text, 'popularity'),
                                    textSection(text, 'pros_cons'),
                                    textSection(text, 'enumeration_des'),
                                    SingleChildScrollView(
                                   child: Column(
                                     children: [
                                       ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: text['enumeration'].length ~/ 2,
                                              itemBuilder: (context, index) {
                                                final evenIndex = index * 2;
                                                final oddIndex = evenIndex + 1;
                                                try {
                                                  return Card(
                                                    color: Color(
                                                        int.parse(text['color'])),
                                                    elevation: 2,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(0.0),
                                                    ),
                                                    child: ExpansionTile(
                                                      title: Text(
                                                          text['enumeration'][evenIndex]
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
                                                              text['enumeration'][oddIndex]
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
                                                catch (e) {} // try-catch za card
                                              },
                                            ),
                                     ],
                                   ),
                                 ),
                                    textSection(text, 'implementation')
                                  ]
                              )
                          ),
                        );
                  }catch(e){}
                }}
            return const Text('Nema podataka za trenutnu tehnologiju');
           }
          },
    );
  }

  SizedBox textSection(QueryDocumentSnapshot<Object?> text, String textDoc) {
    return SizedBox(
      height: (text[textDoc] != null && text[textDoc].isNotEmpty)
          ? null : 0.0,
      child: Text((){
        try { return text[textDoc].replaceAll("\\n", "\n").replaceAll("\\t", "\t");
        } catch (e) { return ''; }
        }(),
        style: tStyle,
        textAlign: TextAlign.justify,
      ),
    );
  }
}

