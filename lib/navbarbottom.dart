import 'package:flutter/material.dart';
import 'package:flutter_library/menu/menu_historybooks.dart';
import 'package:flutter_library/menu/menu_home.dart';
import 'package:flutter_library/menu/menu_profile.dart';

class LayoutNavigationBarBottom extends StatefulWidget {
  const LayoutNavigationBarBottom({super.key});

  @override
  State<LayoutNavigationBarBottom> createState() => LayoutNavigationBarBottomState();
}

class LayoutNavigationBarBottomState extends State<LayoutNavigationBarBottom> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MenuHome(),
    MenuHistoryBook(),
    MenuProfile(),
  ];

  void onBarTapped(int index) {
  setState(() {
    _currentIndex = index;
  });
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onBarTapped,
          items: 
          <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
