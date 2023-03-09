import 'package:flutter/material.dart';
import 'package:flutter_first_app/bmi_calc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home.dart';

void main() async {
  // init Hive
  await Hive.initFlutter();

  // open a Box
  var box = await Hive.openBox('todoBox');

  // run App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      routes: {
        '/': (context) => const MyHomePage(title: 'TODO App Home Page'),
        '/calculator': (context) => const BMICalculator(),
      },
      initialRoute: '/',
      // home: const MyHomePage(title: 'TODO App Home Page'),
    );
  }
}
