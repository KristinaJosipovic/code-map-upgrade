import 'package:code_map/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_map/articles/article_page.dart';
import 'package:code_map/search_screen/searchScreen.dart';

String currentTech = "";
String urlImage = "";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentCategory = "Funkcionalno";
  int _currenIndex = 0;
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
            child: IconButton(onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchScreen()),
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
          //_searchField(),
          const SizedBox(height: 20,),
          _categoriesSection(),
          const SizedBox(height: 30,),
          _languagesFrameworksSection(currentCategory),
          const SizedBox(height: 40,),
          // _popularModelSection(),
          // const SizedBox(height: 40,),
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
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins'
                ),
              ),
            ),
            const SizedBox(height: 15,),
            SizedBox(
              height: 240,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Tehnologije').snapshots(),
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
                              //color: Color(int.parse(tech['color']))
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
                                Image.asset(tech['slika'], width: 100, height: 100,),
                                //Image.network(FirebaseStorageService().getImage(tech['slika']) as String, width:100, height:100), ne radi
                                Column(
                                  children: [
                                    Text(
                                      tech['naziv'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const Text(
                                      'To be added', // change the text
                                      style: TextStyle(
                                          color: Color(0xff7B6F72),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    currentTech = tech['naziv'];
                                    urlImage = tech['slika'];
                                    getCurrentTech();
                                    getUrlImage();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MainArticle(currentTech: currentTech, imageUrl: urlImage,)),
                                      );
                                  },
                                  child: Container(
                                    height: 45,
                                    width: 130,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          colors: [ // colors should be upgraded
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
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 15,),
        SizedBox(
          height: 140,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Kategorije').orderBy('number').snapshots(),
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
                            ?  Color(int.parse(cat['boxColor'])).withOpacity(0.4)
                            : Color(int.parse(cat['boxColor'])).withOpacity(0.7),
                             borderRadius: BorderRadius.circular(20),
                             border: Border.all(
                                 color:  currentCategory == cat['name']
                                 ? Colors.black.withOpacity(0.5)
                                 : Color(int.parse(cat['boxColor'])).withOpacity(0.7), width: 2),
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
                                fontSize: 14,
                                fontFamily: 'Poppins',
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
/*
  Container _searchField() {
    return Container(
          margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xff1D1617).withOpacity(0.11),
                blurRadius: 40,
                spreadRadius: 0.0,
              )
            ]
          ),
          child: TextField(
            onTap: (){
              Navigator.push(
                     context,
                    MaterialPageRoute(
                    builder: (context) => SearchScreen()),
              );
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(15),
              hintText: 'Pretraži...',
              hintStyle: const TextStyle(
                color: Color(0xffDDDADA),
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/Search.svg'),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const VerticalDivider(
                        color:  Colors.black,
                        indent: 10,
                        endIndent: 10,
                        thickness: 0.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset('assets/icons/Filter.svg'),
                      ),
                    ],
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
  }*/
  /*_bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currenIndex,
      fixedColor: Colors.lightBlue.shade200,
      backgroundColor: Colors.blue.shade300,
      elevation: 4,
      onTap: (int index) {
        if (index == 0) {
          setState(() {
            _currenIndex = index;
          });
        } else if (index == 1) {
          setState(() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SideMenu()));
          });
        } else if (index == 2) {
          setState(() {});
        } else if (index == 3) {
          setState(() {
            _currenIndex = index;
          });
        } else if (index == 4) {
          setState(() {
            _currenIndex = index;
          });
        }
      },
      unselectedItemColor: Colors.white,
      items: items,
      type: BottomNavigationBarType.fixed,
    );
  }

  // list of items
  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
      icon: Icon(IconlyBold.home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(IconlyBold.edit),
      label: "Upload",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        IconlyBold.scan,
        color: Colors.white,
      ),
      label: "Scan",
    ),
    BottomNavigationBarItem(
      icon: Icon(IconlyBold.notification),
      label: "Notification",
    ),
    BottomNavigationBarItem(
      icon: Icon(IconlyBold.profile),
      label: "Profile",
    ),
  ];*/
}
