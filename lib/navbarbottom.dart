import 'package:flutter/material.dart';
import 'package:flutter_library/data/model/user.dart';
import 'package:flutter_library/menu/menu_historybooks.dart';
import 'package:flutter_library/menu/menu_home.dart';
import 'package:flutter_library/menu/menu_profile.dart';


class LayoutNavigationBarBottom extends StatefulWidget {
  final User activeUser;
  const LayoutNavigationBarBottom({super.key, required this.activeUser});

  @override
  State<LayoutNavigationBarBottom> createState() => LayoutNavigationBarBottomState();
}

class LayoutNavigationBarBottomState extends State<LayoutNavigationBarBottom> {
  int _currentIndex = 0;
  // children must be created inside build so we can access `widget` safely

  void onBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      MenuHome(activeUser: widget.activeUser),
      MenuHistoryBook(),
      MenuProfile(activeUser: widget.activeUser),
    ];

    return Column(
      children: [
        Expanded(child: children[_currentIndex]),
        BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onBarTapped,
          items: const <BottomNavigationBarItem>[
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
      ],
    );
  }
}
