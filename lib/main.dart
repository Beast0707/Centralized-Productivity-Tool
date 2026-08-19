import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/db_service.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DBService.instance;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Cleaner UI
      title: 'Note App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: const HomeScreen(),
      routes: {
        '/vaultHome': (context) => Scaffold(
          body: Center(child: Text("Vault Unlocked 🔓")),
        ),
      },
    );
  }
}