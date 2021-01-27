import 'package:decibel_meter/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider<MicData>(
          create: (_) => MicData(), child: HomeScreen()),
    );
  }
}
