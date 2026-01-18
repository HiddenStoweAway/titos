import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:titos/homepage.dart';
import 'package:titos/foods_manager.dart';
import 'package:titos/save_manager.dart';

final VERSION_NUMBER = '1.4';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('foods');

  print(VERSION_NUMBER);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // INITALIZE STATIC INSTANCES
    FoodsManager.instance = FoodsManager();
    SaveManager.instance = SaveManager();


    return MaterialApp(
      title: 'TITOS',
      home: const Homepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}