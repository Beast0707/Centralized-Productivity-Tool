// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'calendar_screen.dart';
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
  // Controller to handle the search input text
  final TextEditingController _searchController = TextEditingController();
  //test cases remove
  //TASK
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

    if (tasks.isEmpty) {
      print("No tasks found to toggle");
      return;
    }

    Task task = tasks.first;

    print("Before Toggle: ${task.isCompleted}");

    await DBService.instance.toggleTaskCompletion(task);

    final updatedTasks =
    await DBService.instance.getTasksByDate(DateTime.now());

    print("After Toggle: ${updatedTasks.first.isCompleted}");
  }

  Future<void> testUpdateTask() async {
    final tasks = await DBService.instance.getTasksByDate(DateTime.now());

    if (tasks.isEmpty) {
      print("No tasks found to update");
      return;
    }

    Task task = tasks.first;

    task.title = "UPDATED TITLE ";
    task.description = "UPDATED DESC";
    task.updatedAt = DateTime.now();

    await DBService.instance.updateTask(task);

    final updatedTasks =
    await DBService.instance.getTasksByDate(DateTime.now());

    print("Updated Task: ${updatedTasks.first}");
  }

  Future<void> testDeleteTask() async {
    final tasks = await DBService.instance.getTasksByDate(DateTime.now());

    if (tasks.isEmpty) {
      print("No tasks to delete");
      return;
    }

    Task task = tasks.first;

    print("Deleting Task ID: ${task.id}");

    await DBService.instance.deleteTask(task.id!);

    final updatedTasks =
    await DBService.instance.getTasksByDate(DateTime.now());

    print("Remaining Tasks: $updatedTasks");
  }

  //NOTES
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

    if (notes.isEmpty) {
      print("No notes to update");
      return;
    }

    Note note = notes.first;

    note.title = "UPDATED NOTE ";
    note.content = "UPDATED CONTENT";
    note.updatedAt = DateTime.now();

    await DBService.instance.updateNote(note);

    final updated = await DBService.instance.getAllNotes();
    print("Updated Notes: $updated");
  }

  Future<void> testDeleteNote() async {
    final notes = await DBService.instance.getAllNotes();

    if (notes.isEmpty) {
      print("No notes to delete");
      return;
    }

    Note note = notes.first;

    print("Deleting Note ID: ${note.id}");

    await DBService.instance.deleteNote(note.id!);

    final updated = await DBService.instance.getAllNotes();
    print("Remaining Notes: $updated");
  }

  //Events
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
    final events =
    await DBService.instance.getEventsByDate(DateTime.now());

    print("Events: $events");
  }

  Future<void> testUpdateEvent() async {
    final events =
    await DBService.instance.getEventsByDate(DateTime.now());

    if (events.isEmpty) {
      print("No events to update");
      return;
    }

    Event event = events.first;

    event.title = "UPDATED EVENT ";
    event.updatedAt = DateTime.now();

    await DBService.instance.updateEvent(event);

    final updated =
    await DBService.instance.getEventsByDate(DateTime.now());

    print("Updated Events: $updated");
  }

  Future<void> testDeleteEvent() async {
    final events =
    await DBService.instance.getEventsByDate(DateTime.now());

    if (events.isEmpty) {
      print("No events to delete");
      return;
    }

    Event event = events.first;

    print("Deleting Event ID: ${event.id}");

    await DBService.instance.deleteEvent(event.id!);

    final updated =
    await DBService.instance.getEventsByDate(DateTime.now());

    print("Remaining Events: $updated");
  }

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

              const SizedBox(height: 20),

              // 🔴 TEMP BUTTON (REMOVE LATER)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarScreen(),
                    ),
                  );
                },
                child: const Text("TEMP: Go to Calendar"),
              ),

              //TASKS
              ElevatedButton(
                onPressed: () {
                  insertTestTask();
                },
                child: const Text("TEMP: Insert Task"),
              ),

              ElevatedButton(
                onPressed: () {
                  testToggleTask();
                },
                child: const Text("TEST: Toggle Task"),
              ),

              ElevatedButton(
                onPressed: () {
                  testUpdateTask();
                },
                child: const Text("TEST: Update Task"),
              ),

              ElevatedButton(
                onPressed: () {
                  testDeleteTask();
                },
                child: const Text("TEST: Delete Task"),
              ),

              //NOTES
              ElevatedButton(
                onPressed: () => testInsertNote(),
                child: const Text("TEST: Insert Note"),
              ),

              ElevatedButton(
                onPressed: () => testGetNotes(),
                child: const Text("TEST: Get Notes"),
              ),

              ElevatedButton(
                onPressed: () => testUpdateNote(),
                child: const Text("TEST: Update Note"),
              ),

              ElevatedButton(
                onPressed: () => testDeleteNote(),
                child: const Text("TEST: Delete Note"),
              ),

              //EVENTS
              ElevatedButton(
                onPressed: () => testInsertEvent(),
                child: const Text("TEST: Insert Event"),
              ),

              ElevatedButton(
                onPressed: () => testGetEvents(),
                child: const Text("TEST: Get Events"),
              ),

              ElevatedButton(
                onPressed: () => testUpdateEvent(),
                child: const Text("TEST: Update Event"),
              ),

              ElevatedButton(
                onPressed: () => testDeleteEvent(),
                child: const Text("TEST: Delete Event"),
              ),

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