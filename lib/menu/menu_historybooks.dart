import 'package:flutter/material.dart';

class MenuHistoryBook extends StatelessWidget {
  const MenuHistoryBook({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Ini adalah halaman History Books',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}