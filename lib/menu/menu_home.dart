import 'package:flutter/material.dart';

class MenuHome extends StatelessWidget {
  const MenuHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Ini adalah halaman Home',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}