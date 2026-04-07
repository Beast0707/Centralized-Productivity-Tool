import 'package:flutter/material.dart';
import '../screens/calendar_screen.dart';
import '../screens/home_screen.dart';
import '../screens/vault_screen.dart';
import '../screens/tasks_screen.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;
  const AppSidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView(
            children: [
              _SidebarItem(
                icon: Icons.home,
                label: 'Home',
                route: '/home',
                currentRoute: currentRoute,
                destination: HomeScreen(),
              ),
              _SidebarItem(
                icon: Icons.calendar_today,
                label: 'Calendar',
                route: '/calendar',
                currentRoute: currentRoute,
                destination: CalendarScreen(),
              ),
              _SidebarItem(
                icon: Icons.lock,
                label: 'Vault',
                route: '/vault',
                currentRoute: currentRoute,
                destination: VaultScreen(),
              ),
              _SidebarItem(
                icon: Icons.task,
                label: 'Task',
                route: '/task',
                currentRoute: currentRoute,
                destination: TasksScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final String currentRoute;
  final Widget destination;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.currentRoute,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentRoute == route;
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: isActive,
      onTap: () {
        Navigator.pop(context);
        if (!isActive) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        }
      },
    );
  }
}