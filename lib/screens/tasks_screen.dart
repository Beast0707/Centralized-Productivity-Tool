import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

const Color _kBackgroundColor = Color(0xFFE5E5E5);
const Color _kTextSub = Color(0xFF666666);

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with SingleTickerProviderStateMixin {
  // ✅ Moved here from TasksScreen
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedPriority = 'Medium';
  String _selectedCategory = 'Personal';

  final List<String> _priorities = ['Low', 'Medium', 'High'];
  final List<String> _categories = ['Personal', 'Work', 'Shopping', 'Health', 'Other'];

  final List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get _pendingTasks =>
      _tasks.where((t) => !t['done']).toList();

  List<Map<String, dynamic>> get _completedTasks =>
      _tasks.where((t) => t['done']).toList();

  // ✅ Moved inside the State class
  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.grid_view_rounded, size: 28, color: _kTextSub),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ],
    );
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High': return Colors.redAccent;
      case 'Medium': return Colors.orangeAccent;
      case 'Low': return Colors.green;
      default: return Colors.grey;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Work': return Icons.work_outline;
      case 'Shopping': return Icons.shopping_cart_outlined;
      case 'Health': return Icons.favorite_border;
      case 'Personal': return Icons.person_outline;
      default: return Icons.label_outline;
    }
  }

  void _addTask() {
    if (_taskController.text.trim().isEmpty) return;
    setState(() {
      _tasks.add({
        'title': _taskController.text.trim(),
        'desc': _descController.text.trim(),
        'priority': _selectedPriority,
        'category': _selectedCategory,
        'done': false,
        'createdAt': DateTime.now(),
      });
    });
    _taskController.clear();
    _descController.clear();
    _selectedPriority = 'Medium';
    _selectedCategory = 'Personal';
    Navigator.pop(context);
  }

  void _toggleTask(int index, List<Map<String, dynamic>> list) {
    setState(() {
      list[index]['done'] = !list[index]['done'];
    });
  }

  void _deleteTask(Map<String, dynamic> task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              top: 24,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("New Task", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextField(
                  controller: _taskController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Task title',
                    prefixIcon: Icon(Icons.edit_outlined),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _descController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Description (optional)',
                    prefixIcon: Icon(Icons.notes_outlined),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text("Priority", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                SizedBox(height: 8),
                Row(
                  children: _priorities.map((p) {
                    final selected = _selectedPriority == p;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setModalState(() => _selectedPriority = p),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? _priorityColor(p) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(p,
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                Text("Category", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final selected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setModalState(() => _selectedCategory = cat),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected ? Colors.black : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(_categoryIcon(cat), size: 14, color: selected ? Colors.white : Colors.black54),
                                SizedBox(width: 4),
                                Text(cat,
                                  style: TextStyle(
                                    color: selected ? Colors.white : Colors.black54,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text("Add Task",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task, int index, List<Map<String, dynamic>> list) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => _deleteTask(task),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: Offset(0, 3))],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: GestureDetector(
            onTap: () => _toggleTask(index, list),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task['done'] ? Colors.black : Colors.transparent,
                border: Border.all(color: task['done'] ? Colors.black : Colors.grey.shade400, width: 2),
              ),
              child: task['done'] ? Icon(Icons.check, color: Colors.white, size: 14) : null,
            ),
          ),
          title: Text(task['title'],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              decoration: task['done'] ? TextDecoration.lineThrough : null,
              color: task['done'] ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task['desc'] != null && task['desc'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(task['desc'],
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _priorityColor(task['priority']).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(task['priority'],
                      style: TextStyle(color: _priorityColor(task['priority']), fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 8),
                  Row(
                    children: [
                      Icon(_categoryIcon(task['category']), size: 12, color: Colors.grey),
                      SizedBox(width: 3),
                      Text(task['category'], style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          trailing: Icon(Icons.drag_handle, color: Colors.grey.shade300),
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
          SizedBox(height: 12),
          Text(message, style: TextStyle(color: Colors.grey, fontSize: 15)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskController.dispose();
    _descController.dispose();
    _searchController.dispose(); // ✅ also dispose this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      drawer: const AppSidebar(currentRoute: '/home'),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 78, 78),
        title: Text("Tasks", style: TextStyle(color: Colors.white)),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade400,
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
                  padding: EdgeInsets.all(16),
                  itemCount: _pendingTasks.length,
                  itemBuilder: (_, i) => _buildTaskCard(_pendingTasks[i], i, _pendingTasks),
                ),
          _completedTasks.isEmpty
              ? _buildEmptyState("Nothing completed yet.", Icons.task_alt)
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _completedTasks.length,
                  itemBuilder: (_, i) => _buildTaskCard(_completedTasks[i], i, _completedTasks),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskSheet,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("New Task", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}