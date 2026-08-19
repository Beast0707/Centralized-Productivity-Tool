// lib/screens/home_screen.dart

import 'package:flutter/material.dart';

import '../core/app_routes.dart';
import '../debug/database_test_actions.dart';
import '../widgets/sidebar.dart';

const Color _kBackgroundColor = Color(0xFFE5E5E5);
const Color _kTextSub = Color(0xFF666666);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// Development-only database test actions.
  ///
  /// Keeping these outside HomeScreen prevents temporary database
  /// testing code from becoming part of the screen's permanent logic.
  final DatabaseTestActions _testActions = DatabaseTestActions();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _kBackgroundColor,

      // Navigation is handled through the centralized route system.
      drawer: const AppSidebar(),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(context),

                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Recent notes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(221, 59, 59, 59),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Temporary development/testing controls.
                //
                // These are intentionally still visible for now because
                // they are currently being used to demonstrate database
                // and page connections.
                _buildTestActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestActions() {
    return ExpansionTile(
      title: const Text('Test Actions'),
      children: [
        _buildTestButton(
          label: 'TEMP: Go to Calendar',
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.calendar,
            );
          },
        ),

        // ===== TASK TESTS =====

        _buildTestButton(
          label: 'TEMP: Insert Task',
          onPressed: () => _testActions.insertTestTask(),
        ),

        _buildTestButton(
          label: 'TEST: Get Tasks By Date',
          onPressed: () => _testActions.testGetTasksByDate(),
        ),

        _buildTestButton(
          label: 'TEST: Toggle Task',
          onPressed: () => _testActions.testToggleTask(),
        ),

        _buildTestButton(
          label: 'TEST: Update Task',
          onPressed: () => _testActions.testUpdateTask(),
        ),

        _buildTestButton(
          label: 'TEST: Delete Task',
          onPressed: () => _testActions.testDeleteTask(),
        ),

        // ===== NOTE TESTS =====

        _buildTestButton(
          label: 'TEST: Insert Note',
          onPressed: () => _testActions.testInsertNote(),
        ),

        _buildTestButton(
          label: 'TEST: Get Notes',
          onPressed: () => _testActions.testGetNotes(),
        ),

        _buildTestButton(
          label: 'TEST: Update Note',
          onPressed: () => _testActions.testUpdateNote(),
        ),

        _buildTestButton(
          label: 'TEST: Delete Note',
          onPressed: () => _testActions.testDeleteNote(),
        ),

        // ===== EVENT TESTS =====

        _buildTestButton(
          label: 'TEST: Insert Event',
          onPressed: () => _testActions.testInsertEvent(),
        ),

        _buildTestButton(
          label: 'TEST: Get Events',
          onPressed: () => _testActions.testGetEvents(),
        ),

        _buildTestButton(
          label: 'TEST: Update Event',
          onPressed: () => _testActions.testUpdateEvent(),
        ),

        _buildTestButton(
          label: 'TEST: Delete Event',
          onPressed: () => _testActions.testDeleteEvent(),
        ),
      ],
    );
  }

  Widget _buildTestButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.grid_view_rounded,
            size: 28,
            color: _kTextSub,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: _kBackgroundColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
            child: TextField(
              controller: _searchController,
              cursorColor: _kTextSub,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(
                  color: _kTextSub,
                  fontSize: 16,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: _kTextSub,
                  size: 22,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 18,
                          color: _kTextSub,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (_) {
                // The search system will be connected later.
                //
                // Keeping setState here preserves the current UI behavior
                // so that the clear button updates correctly.
                setState(() {});
              },
            ),
          ),
        ),

        const SizedBox(width: 8),

        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert_rounded,
            size: 28,
            color: _kTextSub,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onSelected: (value) {
            debugPrint('Selected: $value');
          },
          itemBuilder: (context) => [
            _buildMenuItem(
              'share',
              Icons.share,
              'Share',
            ),
            _buildMenuItem(
              'export',
              Icons.file_download_outlined,
              'Export',
            ),
            _buildMenuItem(
              'view',
              Icons.visibility_outlined,
              'View',
            ),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String text,
  ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.black87,
          ),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}