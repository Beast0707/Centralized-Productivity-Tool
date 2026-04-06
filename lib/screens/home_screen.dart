// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    debugPrint("📥 Loading tasks...");
    final data = await DBService.instance.getTasksByDate(DateTime.now());

    debugPrint("📊 Loaded Tasks: $data");

    setState(() {
      tasks = data;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // =======================
  // 🔴 TASKS (WITH LOGS)
  // =======================

  Future<void> insertTestTask() async {
    debugPrint("🟡 Inserting Task...");

    Task task = Task(
      title: "test task2",
      description: "test task2",
      date: DateTime.now(),
      isCompleted: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    int id = await DBService.instance.insertTask(task);

    debugPrint("✅ Inserted Task ID: $id");

    loadTasks();
  }

  Future<void> testToggleTask() async {
    final data = await DBService.instance.getTasksByDate(DateTime.now());

    if (data.isEmpty) {
      debugPrint("❌ No tasks to toggle");
      return;
    }

    debugPrint("🔄 Before Toggle: ${data.first.isCompleted}");

    await DBService.instance.toggleTaskCompletion(data.first);

    final updated =
    await DBService.instance.getTasksByDate(DateTime.now());

    debugPrint("✅ After Toggle: ${updated.first.isCompleted}");

    loadTasks();
  }

  Future<void> testUpdateTask() async {
    final data = await DBService.instance.getTasksByDate(DateTime.now());

    if (data.isEmpty) {
      debugPrint("❌ No tasks to update");
      return;
    }

    Task task = data.first;

    debugPrint("📝 Before Update: ${task.title}");

    task.title = "UPDATED TITLE";
    task.description = "UPDATED DESC";
    task.updatedAt = DateTime.now();

    await DBService.instance.updateTask(task);

    final updated =
    await DBService.instance.getTasksByDate(DateTime.now());

    debugPrint("✅ After Update: ${updated.first}");

    loadTasks();
  }

  Future<void> testDeleteTask() async {
    final data = await DBService.instance.getTasksByDate(DateTime.now());

    if (data.isEmpty) {
      debugPrint("❌ No tasks to delete");
      return;
    }

    debugPrint("🗑️ Deleting Task ID: ${data.first.id}");

    await DBService.instance.deleteTask(data.first.id!);

    final updated =
    await DBService.instance.getTasksByDate(DateTime.now());

    debugPrint("✅ Remaining Tasks: $updated");

    loadTasks();
  }

  // =======================
  // 📝 NOTES (WITH LOGS)
  // =======================

  Future<void> testInsertNote() async {
    debugPrint("🟡 Inserting Note...");

    int id = await DBService.instance.insertNote(
      Note(
        title: "Test Note",
        content: "This is a test note",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    debugPrint("✅ Inserted Note ID: $id");
  }

  Future<void> testGetNotes() async {
    debugPrint("📥 Fetching Notes...");
    final notes = await DBService.instance.getAllNotes();
    debugPrint("📊 Notes: $notes");
  }

  Future<void> testUpdateNote() async {
    final notes = await DBService.instance.getAllNotes();

    if (notes.isEmpty) {
      debugPrint("❌ No notes to update");
      return;
    }

    Note note = notes.first;

    debugPrint("📝 Before Update: ${note.title}");

    note.title = "UPDATED NOTE";
    note.content = "UPDATED CONTENT";
    note.updatedAt = DateTime.now();

    await DBService.instance.updateNote(note);

    debugPrint("✅ Note Updated");
  }

  Future<void> testDeleteNote() async {
    final notes = await DBService.instance.getAllNotes();

    if (notes.isEmpty) {
      debugPrint("❌ No notes to delete");
      return;
    }

    debugPrint("🗑️ Deleting Note ID: ${notes.first.id}");

    await DBService.instance.deleteNote(notes.first.id!);

    debugPrint("✅ Note Deleted");
  }

  // =======================
  // 📅 EVENTS (WITH LOGS)
  // =======================

  Future<void> testInsertEvent() async {
    debugPrint("🟡 Inserting Event...");

    int id = await DBService.instance.insertEvent(
      Event(
        title: "Test Event",
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    debugPrint("✅ Inserted Event ID: $id");
  }

  Future<void> testGetEvents() async {
    debugPrint("📥 Fetching Events...");

    final events =
    await DBService.instance.getEventsByDate(DateTime.now());

    debugPrint("📊 Events: $events");
  }

  Future<void> testUpdateEvent() async {
    final events =
    await DBService.instance.getEventsByDate(DateTime.now());

    if (events.isEmpty) {
      debugPrint("❌ No events to update");
      return;
    }

    Event event = events.first;

    debugPrint("📝 Before Update: ${event.title}");

    event.title = "UPDATED EVENT";
    event.updatedAt = DateTime.now();

    await DBService.instance.updateEvent(event);

    debugPrint("✅ Event Updated");
  }

  Future<void> testDeleteEvent() async {
    final events =
    await DBService.instance.getEventsByDate(DateTime.now());

    if (events.isEmpty) {
      debugPrint("❌ No events to delete");
      return;
    }

    debugPrint("🗑️ Deleting Event ID: ${events.first.id}");

    await DBService.instance.deleteEvent(events.first.id!);

    debugPrint("✅ Event Deleted");
  }

  // =======================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _kBackgroundColor,
      drawer: const AppSidebar(currentRoute: '/home'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Recent Tasks',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(221, 59, 59, 59),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // TASK LIST UI
              Expanded(
                child: tasks.isEmpty
                    ? const Center(child: Text("No tasks yet"))
                    : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Text(task.description ?? ""),
                        trailing: Checkbox(
                          value: task.isCompleted == 1,
                          onChanged: (_) async {
                            debugPrint(
                                "🔄 UI Toggle Task ID: ${task.id}");

                            await DBService.instance
                                .toggleTaskCompletion(task);

                            loadTasks();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 🔧 DEV PANEL
              ExpansionTile(
                title: const Text("⚙️ Developer Test Panel"),
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton(onPressed: insertTestTask, child: Text("Add Task")),
                      ElevatedButton(onPressed: testToggleTask, child: Text("Toggle Task")),
                      ElevatedButton(onPressed: testUpdateTask, child: Text("Update Task")),
                      ElevatedButton(onPressed: testDeleteTask, child: Text("Delete Task")),

                      ElevatedButton(onPressed: testInsertNote, child: Text("Add Note")),
                      ElevatedButton(onPressed: testGetNotes, child: Text("Get Notes")),
                      ElevatedButton(onPressed: testUpdateNote, child: Text("Update Note")),
                      ElevatedButton(onPressed: testDeleteNote, child: Text("Delete Note")),

                      ElevatedButton(onPressed: testInsertEvent, child: Text("Add Event")),
                      ElevatedButton(onPressed: testGetEvents, child: Text("Get Events")),
                      ElevatedButton(onPressed: testUpdateEvent, child: Text("Update Event")),
                      ElevatedButton(onPressed: testDeleteEvent, child: Text("Delete Event")),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CalendarScreen()),
                          );
                        },
                        child: Text("Go Calendar"),
                      ),
                    ],
                  ),
                ],
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
              border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: _kTextSub),
                border: InputBorder.none,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () =>
                      setState(() => _searchController.clear()),
                )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),

        const SizedBox(width: 8),

        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, size: 28, color: _kTextSub),
          itemBuilder: (context) => [
            _buildMenuItem('share', Icons.share, 'Share'),
            _buildMenuItem('export', Icons.file_download_outlined, 'Export'),
            _buildMenuItem('view', Icons.visibility_outlined, 'View'),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      String value, IconData icon, String text) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}