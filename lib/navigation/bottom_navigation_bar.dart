import 'package:flutter/material.dart';
import 'package:code_map/screens/favorite_screen.dart';
import 'package:code_map/screens/help_screen.dart';
import 'package:code_map/user_authentication/login.dart';
import 'package:code_map/screens/search_screen/search_screen.dart';
import 'package:code_map/screens/home_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigation> {
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
      unselectedItemColor: Colors.black,
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
    label: "Prijava",
  ),
];
