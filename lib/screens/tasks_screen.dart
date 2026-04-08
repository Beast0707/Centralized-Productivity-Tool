import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

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
  String _selectedPriority = 'Medium';
  String _selectedCategory = 'Personal';

  final List<String> _priorities = ['Low', 'Medium', 'High'];
  final List<String> _categories = ['Personal', 'Work', 'Shopping', 'Health', 'Other'];

  final List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get _pendingTasks =>
      _tasks.where((t) => !t['done']).toList();

  List<Map<String, dynamic>> get _completedTasks =>
      _tasks.where((t) => t['done']).toList();

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
        title: Text("Tasks", style: TextStyle(color: _kTextSub)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: _kTextSub,
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
        onPressed: () {
          // Do nothing on button press to disable UI
        },
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("New Task", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}