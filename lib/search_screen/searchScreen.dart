import 'package:code_map/home_page.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:code_map/articles/article_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'language_names.dart';
import 'custom_text_field.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  static List previousSearchs = [];
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
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              children: [
                // Search Bar
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0, bottom:20.0),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            )),
                        Expanded(
                          child: CustomTextFormField(
                            hint: "Pretraži...",
                            prefixIcon: Icons.search,
                            controller: searchController,
                            filled: true,
                            suffixIcon: searchController.text.isEmpty
                                ? null
                                : Icons.cancel_sharp,
                            onTapSuffixIcon: () {
                              searchController.clear();
                            },
                            onChanged: (text){
                              setState(() {
                                namesList = tempList;
                              });
                              searchLanguage(text);
                            },
                            onEditingComplete: () {
                              previousSearchs.add(searchController.text);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                            },

                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: namesList.length,
                    itemBuilder: (context, index) {
                      final name = namesList[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 0.0, bottom:0.0),
                        child: GestureDetector(
                          onTap: () {
                            previousSearchs.add(name.name);
                            print('Kliknuli ste na jezik: ${name.name}');
                            print('Kliknuli ste na jezik: ${name.imageUrl}');
                            String currentTech = name.name;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MainArticle(currentTech: name.name, imageUrl: name.imageUrl,)),
                            );
                          },
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              name.name,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black45,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      );
                    },
                  ),
                ),
                // Previous Searches
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: previousSearchs.length,
                      itemBuilder: (context, index) =>
                          previousSearchsItem(index)),
                ),
                const SizedBox(
                  height: 8,
                ),

                // Search Suggestions
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 25.0, top: 10.0, right: 10.0, bottom:20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Prijedlozi za pretraživanje",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          searchSuggestionsTiem("Python"),
                          searchSuggestionsTiem("Java"),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          searchSuggestionsTiem("JavaScript"),
                          searchSuggestionsTiem("C#"),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  previousSearchsItem(int index) {
    if (previousSearchs.length>4) {
      previousSearchs.removeAt(0);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {},
        child: Dismissible(
          key: GlobalKey(),
          onDismissed: (DismissDirection dir) {
            previousSearchs.removeAt(index);
            setState(() {});
          },
          child: Row(
            children: [
              const Icon(
                IconlyLight.time_circle,
                color: Colors.black,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                previousSearchs[index],
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.call_made_outlined,
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }

  searchSuggestionsTiem(String text) {
    return Container(
      margin: EdgeInsets.only(left: 0, right: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration:
      BoxDecoration(
          color: Colors.green.shade300, borderRadius: BorderRadius.circular(15)),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
          fontSize: 14,
        ),
      ),
    );

  }
  void searchLanguage(String query){
    final suggestion = namesList.where((name){
      final search = name.name.toLowerCase();
      final input = query.toLowerCase();
      return search.contains(input);
    }).toList();
    setState(() => namesList = suggestion);
  }
}







