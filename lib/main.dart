import 'package:flutter/material.dart';

import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'screens/calendar_screen.dart';
import 'screens/home_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/vault_screen.dart';
import 'services/db_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Keep the existing DB initialization behavior.
  DBService.instance;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note App',

      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),

      // Keep the current appearance for now.
      // We can change this when dark-mode UI is actually implemented.
      themeMode: ThemeMode.light,

      initialRoute: AppRoutes.home,

      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.notes: (_) => const NotesScreen(),
        AppRoutes.calendar: (_) => CalendarScreen(),
        AppRoutes.tasks: (_) => TasksScreen(),
        AppRoutes.vault: (_) => const VaultScreen(),
      },
    );
  }
}
