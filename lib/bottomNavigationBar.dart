import 'package:flutter/material.dart';
import 'package:code_map/favorites_page/favoritePage.dart';
import 'package:code_map/help.dart';
import 'package:code_map/login.dart';
import 'package:code_map/search_screen/searchScreen.dart';
import 'package:code_map/home_page.dart';

class bottomNavigationBar extends StatefulWidget {
  const bottomNavigationBar({super.key});

  @override
  State<bottomNavigationBar> createState() => _bottomNavigationBarState();
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
  final int _currenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currenIndex,
      fixedColor: Colors.black45,
      backgroundColor: Colors.transparent,
      elevation: 25,
      onTap: (int index) {
        if (index == 0) {
          setState(() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          });
        } else if (index == 1) {
          setState(() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen()));
          });
        } else if (index == 2) {
          setState(() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FavoritePage()));
          });
        } else if (index == 3) {
          setState(() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HelpPage()));
          });
        } else if (index == 4) {
          setState(() {
            setState(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LogIn()));
            });
          });
        }
      },
      unselectedItemColor: Colors.black, // Postavljamo boju neizabranih stavki na crnu
      items: items,
      type: BottomNavigationBarType.fixed,
    );
  }
}

List<BottomNavigationBarItem> items = const [
  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: "Home",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.search),
    label: "Pretraži",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.favorite_outline),
    label: "Omiljeno",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.chat_outlined),
    label: "Pomoć",
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person),
    label: "LogIn",
  ),
];
