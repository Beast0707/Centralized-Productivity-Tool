// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import '../widgets/sidebar.dart';
import '../services/db_service.dart';
import '../models/task_model.dart';
import '../models/note_model.dart';
import '../models/event_model.dart';

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

  //These Test cases of for UI & DB interaction
  //---- REMOVE THIS LATER ----
  Future<void> insertTestTask() async {
    Task task = Task(
      title: "test task2",
      description: "test task2",
      date: DateTime.now(),
      isCompleted: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    int id = await DBService.instance.insertTask(task);
    print("Inserted Task ID: $id");
  }

  Future<void> testToggleTask() async {
    final tasks = await DBService.instance.getTasksByDate(DateTime.now());
    if (tasks.isEmpty) return print("No tasks found to toggle");

    Task task = tasks.first;
    print("Before Toggle: ${task.isCompleted}");
    await DBService.instance.toggleTaskCompletion(task);

    final updatedTasks = await DBService.instance.getTasksByDate(DateTime.now());
    print("After Toggle: ${updatedTasks.first.isCompleted}");
  }

  Future<void> testGetTasksByDate() async {
    final tasks = await DBService.instance.getTasksByDate(DateTime.now());
    print(tasks.isEmpty ? "No tasks found for today" : "Tasks for today: $tasks");
  }

  Future<void> testUpdateTask() async {
    final tasks = await DBService.instance.getTasksByDate(DateTime.now());
    if (tasks.isEmpty) return print("No tasks found to update");

    Task task = tasks.first;
    task.title = "UPDATED TITLE";
    task.description = "UPDATED DESC";
    task.updatedAt = DateTime.now();

    await DBService.instance.updateTask(task);
    final updatedTasks = await DBService.instance.getTasksByDate(DateTime.now());
    print("Updated Task: ${updatedTasks.first}");
  }

  Future<void> testDeleteTask() async {
    final tasks = await DBService.instance.getTasksByDate(DateTime.now());
    if (tasks.isEmpty) return print("No tasks to delete");

    Task task = tasks.first;
    print("Deleting Task ID: ${task.id}");
    await DBService.instance.deleteTask(task.id!);

    final updatedTasks = await DBService.instance.getTasksByDate(DateTime.now());
    print("Remaining Tasks: $updatedTasks");
  }

  // ====== NOTES FUNCTIONS ======
  Future<void> testInsertNote() async {
    Note note = Note(
      title: "Test Note",
      content: "This is a test note",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    int id = await DBService.instance.insertNote(note);
    print("Inserted Note ID: $id");
  }

  Future<void> testGetNotes() async {
    final notes = await DBService.instance.getAllNotes();
    print("Notes: $notes");
  }

  Future<void> testUpdateNote() async {
    final notes = await DBService.instance.getAllNotes();
    if (notes.isEmpty) return print("No notes to update");

    Note note = notes.first;
    note.title = "UPDATED NOTE";
    note.content = "UPDATED CONTENT";
    note.updatedAt = DateTime.now();

    await DBService.instance.updateNote(note);
    final updated = await DBService.instance.getAllNotes();
    print("Updated Notes: $updated");
  }

  Future<void> testDeleteNote() async {
    final notes = await DBService.instance.getAllNotes();
    if (notes.isEmpty) return print("No notes to delete");

    Note note = notes.first;
    print("Deleting Note ID: ${note.id}");
    await DBService.instance.deleteNote(note.id!);

    final updated = await DBService.instance.getAllNotes();
    print("Remaining Notes: $updated");
  }

  // ====== EVENTS FUNCTIONS ======
  Future<void> testInsertEvent() async {
    Event event = Event(
      title: "Test Event2",
      date: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    int id = await DBService.instance.insertEvent(event);
    print("Inserted Event ID: $id");
  }

  Future<void> testGetEvents() async {
    final events = await DBService.instance.getEventsByDate(DateTime.now());
    print("Events: $events");
  }

  Future<void> testUpdateEvent() async {
    final events = await DBService.instance.getEventsByDate(DateTime.now());
    if (events.isEmpty) return print("No events to update");

    Event event = events.first;
    event.title = "UPDATED EVENT";
    event.updatedAt = DateTime.now();

    await DBService.instance.updateEvent(event);
    final updated = await DBService.instance.getEventsByDate(DateTime.now());
    print("Updated Events: $updated");
  }

  Future<void> testDeleteEvent() async {
    final events = await DBService.instance.getEventsByDate(DateTime.now());
    if (events.isEmpty) return print("No events to delete");

    Event event = events.first;
    print("Deleting Event ID: ${event.id}");
    await DBService.instance.deleteEvent(event.id!);

    final updated = await DBService.instance.getEventsByDate(DateTime.now());
    print("Remaining Events: $updated");
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //Sidebar, Recent notes title, Building test buttons
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _kBackgroundColor,
      drawer: const AppSidebar(currentRoute: '/home'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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

                // ===== TEST DROPDOWN =====
                ExpansionTile(
                  title: const Text("Test Actions"),
                  children: [
                    _buildTestButton(
                      label: "TEMP: Go to Calendar",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CalendarScreen()),
                        );
                      },
                    ),

                    _buildTestButton(
                      label: "TEMP: Insert Task",
                      onPressed: insertTestTask,
                    ),
                    _buildTestButton(
                      label: "TEST: Get Tasks By Date",
                      onPressed: testGetTasksByDate,
                    ),
                    _buildTestButton(
                      label: "TEST: Toggle Task",
                      onPressed: testToggleTask,
                    ),
                    _buildTestButton(
                      label: "TEST: Update Task",
                      onPressed: testUpdateTask,
                    ),
                    _buildTestButton(
                      label: "TEST: Delete Task",
                      onPressed: testDeleteTask,
                    ),

                    _buildTestButton(
                      label: "TEST: Insert Note",
                      onPressed: testInsertNote,
                    ),
                    _buildTestButton(
                      label: "TEST: Get Notes",
                      onPressed: testGetNotes,
                    ),
                    _buildTestButton(
                      label: "TEST: Update Note",
                      onPressed: testUpdateNote,
                    ),
                    _buildTestButton(
                      label: "TEST: Delete Note",
                      onPressed: testDeleteNote,
                    ),

                    _buildTestButton(
                      label: "TEST: Insert Event",
                      onPressed: testInsertEvent,
                    ),
                    _buildTestButton(
                      label: "TEST: Get Events",
                      onPressed: testGetEvents,
                    ),
                    _buildTestButton(
                      label: "TEST: Update Event",
                      onPressed: testUpdateEvent,
                    ),
                    _buildTestButton(
                      label: "TEST: Delete Event",
                      onPressed: testDeleteEvent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestButton({required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  //Topbar
  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.grid_view_rounded, size: 28, color: _kTextSub),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: _kBackgroundColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black.withOpacity(0.1)),
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
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, size: 18, color: _kTextSub),
                  onPressed: () => setState(() => _searchController.clear()),
                )
                    : null,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
        ),
        const SizedBox(width: 8),
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