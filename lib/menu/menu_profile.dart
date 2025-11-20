import 'package:flutter/material.dart';

class MenuProfile extends StatelessWidget {
  const MenuProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Ini adalah halaman Profile',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}