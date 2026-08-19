import 'package:flutter/material.dart';

import '../core/app_routes.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView(
            children: const [
              _SidebarItem(
                icon: Icons.home,
                label: 'Home',
                route: AppRoutes.home,
              ),
              _SidebarItem(
                icon: Icons.note,
                label: 'Notes',
                route: AppRoutes.notes,
              ),
              _SidebarItem(
                icon: Icons.calendar_today,
                label: 'Calendar',
                route: AppRoutes.calendar,
              ),
              _SidebarItem(
                icon: Icons.lock,
                label: 'Vault',
                route: AppRoutes.vault,
              ),
              _SidebarItem(
                icon: Icons.task,
                label: 'Tasks',
                route: AppRoutes.tasks,
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

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isActive = currentRoute == route;

    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: isActive,
      onTap: isActive
          ? () {
              Navigator.of(context).pop();
            }
          : () {
              // Close drawer.
              Navigator.of(context).pop();

              // Navigate using the centralized route system.
              Navigator.of(context).pushReplacementNamed(route);
            },
    );
  }
}