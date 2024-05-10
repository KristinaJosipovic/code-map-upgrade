import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_map/help.dart';
import 'package:code_map/search_screen/search_screen.dart';
import 'package:code_map/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'package:code_map/favorites_page/favorite_page.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String username = "";
  String email = "";

  void getUserData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('Korisnici')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData = querySnapshot.docs.first.data();
        setState(() {
          username = userData['name'];
          email = userData['email'];
        });

      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
                accountName: Text(username,
                  style: const TextStyle(fontFamily: 'Poppins', color: Colors.black),),
                accountEmail: Text(email,
                  style: const TextStyle(fontFamily: 'Poppins', color: Colors.black),),
                decoration: const BoxDecoration(
                gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue, Colors.green],
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                CupertinoIcons.home,
                color: Colors.black,
                size: 25,
              ),
            ),
            title: const Text(
                "Početna", style: TextStyle(
              fontFamily: 'Poppins',)),

          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                CupertinoIcons.search,
                color: Colors.black,
                size: 25,
              ),
            ),
            title: const Text(
                "Pretraži", style: TextStyle(
              fontFamily: 'Poppins',)),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoritePage()));
            },
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                CupertinoIcons.heart,
                color: Colors.black,
                size: 25,
              ),
            ),
            title: const Text(
                "Omiljeni", style: TextStyle(
              fontFamily: 'Poppins',)),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                CupertinoIcons.chat_bubble_text,
                color: Colors.black,
                size: 25,
              ),
            ),
            title: const Text(
                "Pomoć", style: TextStyle(
              fontFamily: 'Poppins',)),
          ),
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              FirebaseAuth.instance.authStateChanges().listen((User? user) {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => const WelcomePage()), (route) => false);
              });
            },
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                CupertinoIcons.person_crop_circle,
                color: Colors.black,
                size: 25,
              ),
            ),
            title: const Text(
                "Prijava", style: TextStyle(
              fontFamily: 'Poppins',)),
          ),
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              FirebaseAuth.instance.authStateChanges().listen((User? user) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomePage()));
              });
            },
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.logout,
                color: Colors.black,
                size: 25,
              ),
            ),
            title: const Text(
                "Odjavite se", style: TextStyle(
              fontFamily: 'Poppins',)),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              SystemNavigator.pop();
            },
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.exit_to_app,
                color: Colors.black,
                size: 25,
              ),
            ),
            title: const Text(
                "Izlazak", style: TextStyle(
              fontFamily: 'Poppins',)),
          ),
        ],
      ),

    );

  }
}


