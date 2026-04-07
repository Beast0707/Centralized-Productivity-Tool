import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/db_service.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DBService.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: 'Note App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: const HomeScreen(),
    );
  }
}