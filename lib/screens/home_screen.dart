import 'package:code_map/navigation/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_map/screens/article_screen.dart';
import 'package:code_map/screens/search_screen/search_screen.dart';

String currentTech = "";
String urlImage = "";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentCategory = "Funkcionalno";
  Color backColor = Colors.white;
  late Color borderColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
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
        title: const Text("Code <map>",
            style: TextStyle(
              fontFamily: 'Poppins-Medium',
              color: Colors.black,
              fontSize: 23,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SearchScreen()),
              );
            }, icon:
            const Icon(
              Icons.search,
              size: 28,
              color: Colors.black87,),
            ),
          )
        ],
      ),
      backgroundColor: backColor,
      body: ListView(
        children: [
          const SizedBox(height: 30,),
          _categoriesSection(),
          const SizedBox(height: 30,),
          _languagesFrameworksSection(currentCategory),
          const SizedBox(height: 40,),
        ],
      ),
    );
  }

  Column _languagesFrameworksSection(String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Jezici i framework-ovi',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins-Medium'
            ),
          ),
        ),
        const SizedBox(height: 15,),
        SizedBox(
          height: 240,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Tehnologije')
                .snapshots(),
            builder: (context, snapshot) {
              List<Container> techWidgets = [];
              if (snapshot.hasData) {
                final technologies = snapshot.data?.docs.reversed.toList();
                for (var tech in technologies!) {
                  try {
                    if (tech['kategorija'] == currentCategory) {
                      final techWidget = Container(
                        width: 210,
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Color(int.parse(tech['color'])),
                            width: 6,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              tech['slika'], width: 100, height: 100,),
                            Column(
                              children: [
                                Text(
                                  tech['naziv'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Poppins-Medium',
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                currentTech = tech['naziv'];
                                urlImage = tech['slika'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      MainArticle(currentTech: currentTech,
                                        imageUrl: urlImage,)
                                  ),
                                );
                              },
                              child: Container(
                                height: 45,
                                width: 130,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [
                                        Colors.blue, Colors.green
                                      ]
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Prikaži',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      fontFamily: 'Poppins-Medium',
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                      techWidgets.add(techWidget);
                    }
                  }
                  catch (error) {}
                }
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 0, right: 20),
                itemCount: techWidgets.length,
                separatorBuilder: (context, index) =>
                const SizedBox(width: 2,),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20,
                        right: 20
                    ),
                    child: techWidgets[index],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Column _categoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Kategorije',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins-Medium',
            ),
          ),
        ),
        const SizedBox(height: 15,),
        SizedBox(
          height: 140,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Kategorije').orderBy(
                'number').snapshots(),
            builder: (context, snapshot) {
              List<GestureDetector> categoryWidgets = [];
              if (snapshot.hasData) {
                final categories = snapshot.data?.docs.reversed.toList();
                for (var cat in categories!) {
                  final categoryWidget = GestureDetector(
                    onTap: () {
                      currentCategory = cat['name'];
                      setState(() {});
                    },
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: currentCategory == cat['name']
                            ? Color(int.parse(cat['boxColor'])).withOpacity(0.4)
                            : Color(int.parse(cat['boxColor'])).withOpacity(
                            0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: currentCategory == cat['name']
                                ? Colors.black.withOpacity(0.5)
                                : Color(int.parse(cat['boxColor'])).withOpacity(
                                0.7), width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(width: 25,),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(cat['iconPath']),
                            ),
                          ),
                          Text(
                            cat['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Poppins-Medium',
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                  categoryWidgets.add(categoryWidget);
                }
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 20),
                itemCount: categoryWidgets.length,
                separatorBuilder: (context, index) =>
                const SizedBox(width: 5,),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: categoryWidgets[index],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}