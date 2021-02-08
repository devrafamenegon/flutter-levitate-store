import 'package:flutter/material.dart';
import 'package:flutter_levitate/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Levitate Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 52, 73, 85),
        // primaryColor: Color.fromARGB(255, 4, 125, 141),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}



/*
  primary: 700 #344955 52, 73, 85
           800 #232F34 35, 47, 52
           600 #4A6572 74, 101, 114

  secondary: 500 #F9AA33 249, 170, 51
*/

