// lib/screens/home_screen.dart
import 'package:flutter/material.dart';

const Color _kBackgroundColor = Color(0xFFE5E5E5);
const Color _kTextSub = Color(0xFF666666);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller to handle the search input text
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            children: [
              _buildTopBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        // Sidebar Button
        IconButton(
          icon: const Icon(Icons.grid_view_rounded, size: 28, color: _kTextSub),
          onPressed: () => debugPrint("Sidebar tapped"),
        ),

        const SizedBox(width: 8),

        // Functional Dummy Search Bar
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: _kBackgroundColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
            ),
            child: TextField(
              controller: _searchController,
              cursorColor: _kTextSub,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: _kTextSub, fontSize: 16),
                prefixIcon: const Icon(Icons.search, color: _kTextSub, size: 22),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                // Added a clear button that appears when text is typed
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, size: 18, color: _kTextSub),
                  onPressed: () => setState(() => _searchController.clear()),
                )
                    : null,
              ),
              onChanged: (value) {
                // Refresh UI to show/hide the clear icon
                setState(() {});
                debugPrint("Searching for: $value");
              },
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Three Dots Menu
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, size: 28, color: _kTextSub),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onSelected: (value) => debugPrint("Selected: $value"),
          itemBuilder: (context) => [
            _buildMenuItem('share', Icons.share, 'Share'),
            _buildMenuItem('export', Icons.file_download_outlined, 'Export'),
            _buildMenuItem('view', Icons.visibility_outlined, 'View'),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(String value, IconData icon, String text) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}