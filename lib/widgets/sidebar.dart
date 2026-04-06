import 'package:flutter/material.dart';
import '../screens/calendar_screen.dart';
import '../screens/home_screen.dart';
import '../screens/vault_screen.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;

  const AppSidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
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
        ],
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
      title: Text(label),
      selected: isActive,
      onTap: () {
        Navigator.pop(context); // close drawer
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