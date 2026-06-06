import 'package:flutter/material.dart';
import 'package:frontend/pages/HomePage.dart';

import 'package:frontend/pages/LoadPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
