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
  String UrlImage = getUrlImage();
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
                                  children: [
                                    Container(
                                      height: (text['intro'] != null && text['intro'].isNotEmpty)
                                          ? null : 0.0,
                                      child: Text(() {
                                        try { return text['intro'].replaceAll("\\n", "\n");
                                        } catch (e) { return ''; }
                                        }(),
                                        style: tStyle,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Image.asset(
                                      UrlImage, width: 200, height: 200,),
                                    Container(
                                      height: (text['history'] != null && text['history'].isNotEmpty)
                                          ? null : 0.0,
                                      child: Text((){
                                            try { return text['history'].replaceAll("\\n", "\n");
                                            } catch (e) { return ''; }
                                            }(),
                                            style: tStyle,
                                            textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Container(
                                      height: (text['interface'] != null && text['interface'].isNotEmpty)
                                          ? null : 0.0,
                                      child: Text((){
                                          try { return text['interface'].replaceAll("\\n", "\n");
                                          } catch (e) { return ''; }
                                          }(),
                                          style: tStyle,
                                          textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Container(
                                      height: (text['syntax'] != null && text['syntax'].isNotEmpty)
                                          ? null : 0.0,
                                      child: Text((){
                                          try { return text['syntax'].replaceAll("\\n", "\n");
                                          } catch (e) { return ''; }
                                          }(),
                                          style: tStyle,
                                          textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Container(
                                      height: (text['extensions'] != null && text['extensions'].isNotEmpty)
                                          ? null : 0.0,
                                      child: Text((){
                                          try { return text['extensions'].replaceAll("\\n", "\n");
                                          } catch (e) { return ''; }
                                          }(),
                                          style: tStyle,
                                          textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Container(
                                      height: (text['use'] != null && text['use'].isNotEmpty)
                                          ? null : 0.0,
                                      child: Text((){
                                          try { return text['use'].replaceAll("\\n", "\n");
                                          } catch (e) { return ''; }
                                           }(),
                                          style: tStyle,
                                          textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Container(
                                      height: (text['popularity'] != null && text['popularity'].isNotEmpty)
                                          ? null : 0.0,
                                      child: Text((){
                                          try { return text['popularity'].replaceAll("\\n", "\n");
                                          } catch (e) { return ''; }
                                         }(),
                                          style: tStyle,
                                          textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    textSection(text, "enumeration_des"),
                                 ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: text['enumeration'].length ~/ 2,
                                        itemBuilder: (context, index) {
                                          final evenIndex = index * 2;
                                          final oddIndex = evenIndex + 1;
                                          return Card(
                                            color: Color(
                                                int.parse(text['color'])),
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  0.0),
                                            ),
                                            child: ExpansionTile(
                                              title: Text(
                                                text['enumeration'][evenIndex].replaceAll("\\n", "\n"),
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                    fontWeight: FontWeight.w600
                                                )
                                              ),
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    text['enumeration'][oddIndex].replaceAll("\\n", "\n"),
                                                    style: tStyle,
                                                    textAlign: TextAlign.justify),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    Container(
                                      height: (text['implementation'] != null && text['implementation'].isNotEmpty)
                                          ? null : 0.0,
                                      child: Text((){
                                          try { return text['implementation'].replaceAll("\\n", "\n");
                                          } catch (e) { return ''; }
                                          }(),
                                          style: tStyle,
                                          textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ]
                              )
                          ),
                        );
                  }catch(e){}
                }}
          return Text('Nema podataka za trenutnu tehnologiju');
           }
          },
    );
  }

  Container textSection(QueryDocumentSnapshot<Object?> text, String textDoc) {
    return Container(
      height: (text[textDoc] != null && text[textDoc].isNotEmpty)
          ? null : 0.0,
      child: Text((){
        try { return text[textDoc].replaceAll("\\n", "\n");
        } catch (e) { return ''; }
      }(),
        style: tStyle,
        textAlign: TextAlign.left,
                                    ),
                                  );
  }
}

