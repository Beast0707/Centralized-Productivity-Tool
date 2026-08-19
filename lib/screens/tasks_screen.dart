import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../services/db_service.dart';
import '../models/task_model.dart';

const Color _kTextSub = Color(0xFF666666);

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  List<Task> _tasks = [];

  List<Task> get _pendingTasks => _tasks.where((t) => t.isCompleted == 0).toList();
  List<Task> get _completedTasks => _tasks.where((t) => t.isCompleted == 1).toList();

  Future<void> _loadTasks() async {
    final tasks = await DBService.instance.getTasksByDate(DateTime.now());
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask() async {
    if (_taskController.text.trim().isEmpty) return;

    final task = Task(
      title: _taskController.text.trim(),
      description: _descController.text.trim(),
      date: DateTime.now(),
      isCompleted: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await DBService.instance.insertTask(task);
    await _loadTasks();

    _taskController.clear();
    _descController.clear();
    Navigator.pop(context);
  }

  Future<void> _toggleTask(Task task) async {
    await DBService.instance.toggleTaskCompletion(task);
    await _loadTasks();
  }

  Future<void> _deleteTask(Task task) async {
    await DBService.instance.deleteTask(task.id!);
    await _loadTasks();
  }

  void _showAddTaskSheet() {
    _taskController.clear();
    _descController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("New Task",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextField(
                controller: _taskController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Task title",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descController,
                decoration: InputDecoration(
                  hintText: "Description (optional)",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text("Add Task", style: TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => _deleteTask(task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: GestureDetector(
            onTap: () => _toggleTask(task),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.isCompleted == 1 ? Colors.lightGreen : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted == 1 ? Colors.black : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: task.isCompleted == 1
                  ? const Icon(Icons.check, color: Colors.black, size: 14)
                  : null,
            ),
          ),
          title: Text(
            task.title ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              decoration: task.isCompleted == 1 ? TextDecoration.lineThrough : null,
              color: task.isCompleted == 1 ? Colors.green : Colors.black,
            ),
          ),
          subtitle: task.description != null && task.description!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    task.description!,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : null,
          trailing: const Icon(Icons.drag_handle, color: Color(0xFFCCCCCC)),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: Colors.grey, fontSize: 15)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskController.dispose();
    _descController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      drawer: AppSidebar(currentRoute: '/task'),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.grid_view_rounded, size: 28, color: _kTextSub),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text("Tasks", style: TextStyle(color: _kTextSub)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: _kTextSub,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: "Pending (${_pendingTasks.length})"),
            Tab(text: "Done (${_completedTasks.length})"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _pendingTasks.isEmpty
              ? _buildEmptyState("No pending tasks.\nTap + to add one!", Icons.checklist)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pendingTasks.length,
                  itemBuilder: (_, i) => _buildTaskCard(_pendingTasks[i]),
                ),
          _completedTasks.isEmpty
              ? _buildEmptyState("Nothing completed yet.", Icons.task_alt)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _completedTasks.length,
                  itemBuilder: (_, i) => _buildTaskCard(_completedTasks[i]),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskSheet,
        backgroundColor: Colors.black,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("New Task", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}