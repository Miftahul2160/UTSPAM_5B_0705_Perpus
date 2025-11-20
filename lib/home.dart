import 'package:flutter/material.dart';
import 'package:flutter_library/navbarbottom.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  }

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.person, size: 30, color: Colors.white), 
            SizedBox(width: 10),
            Text('Username', 
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold
              )),
          SizedBox(width: 20)],
        ),
      ),
      body: LayoutNavigationBarBottom(
        
      )
      
    );
  }
}

