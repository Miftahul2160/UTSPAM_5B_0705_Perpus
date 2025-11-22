import 'package:flutter/material.dart';
import 'package:flutter_library/booklist.dart';
import 'package:flutter_library/login.dart';
import 'package:flutter_library/data/model/user.dart';


class MenuHome extends StatelessWidget {
  final User activeUser;
  const MenuHome({super.key, required this.activeUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text( 'Selamat Datang di Aplikasi Perpustakaan', 
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                )),
              SizedBox(height: 10),
              Text('Aplikasi untuk memudahkan peminjaman buku di perpustakaan.'),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => Booklist()),
                  );
                }, 
              child: Text(  'Mulai Jelajah Buku',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              )),
            ],
          ),
          
          
        ),
      ),
    );
  }
}