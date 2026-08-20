import 'package:flutter/material.dart';

import '../models/task_model.dart';
import '../services/db_service.dart';
import '../widgets/sidebar.dart';

const Color _kTextSub = Color(0xFF666666);

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  late final TabController _tabController;

  List<Task> _tasks = [];

  bool _isLoading = false;
  bool _isSaving = false;

  List<Task> get _pendingTasks =>
      _tasks.where((task) => task.isCompleted == 0).toList();

  List<Task> get _completedTasks =>
      _tasks.where((task) => task.isCompleted == 1).toList();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskController.dispose();
    _descController.dispose();

    super.dispose();
  }

  Future<void> _loadTasks() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final tasks = await DBService.instance.getTasksByDate(
        DateTime.now(),
      );

      if (!mounted) return;

      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      debugPrint('Failed to load tasks: $e');

      _showErrorSnackBar('Failed to load tasks.');
    }
  }

  Future<void> _addTask() async {
    final title = _taskController.text.trim();
    final description = _descController.text.trim();

    if (title.isEmpty || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final now = DateTime.now();

    final task = Task(
      title: title,
      description: description,
      date: now,
      isCompleted: 0,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await DBService.instance.insertTask(task);

      await _loadTasks();

      if (!mounted) return;

      _taskController.clear();
      _descController.clear();

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      debugPrint('Failed to add task: $e');

      _showErrorSnackBar('Failed to add task.');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _toggleTask(Task task) async {
    try {
      await DBService.instance.toggleTaskCompletion(task);
      await _loadTasks();
    } catch (e) {
      if (!mounted) return;

      debugPrint('Failed to toggle task: $e');

      _showErrorSnackBar('Failed to update task.');
    }
  }

  Future<void> _deleteTask(Task task) async {
    final id = task.id;

    if (id == null) {
      debugPrint('Cannot delete task without an ID.');
      return;
    }

    try {
      await DBService.instance.deleteTask(id);
      await _loadTasks();
    } catch (e) {
      if (!mounted) return;

      debugPrint('Failed to delete task: $e');

      _showErrorSnackBar('Failed to delete task.');
    }
  }

  void _showAddTaskSheet() {
    _taskController.clear();
    _descController.clear();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'New Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _taskController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Task title',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (_) {
                      setSheetState(() {});
                    },
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _descController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Description (optional)',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _taskController.text.trim().isEmpty ||
                              _isSaving
                          ? null
                          : _addTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade400,
                        disabledForegroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Add Task',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    final bool completed = task.isCompleted == 1;

    return Dismissible(
      key: ValueKey(
        task.id ?? '${task.title}-${task.createdAt}',
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return true;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) {
        _deleteTask(task);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          leading: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _toggleTask(task),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed
                    ? Colors.lightGreen
                    : Colors.transparent,
                border: Border.all(
                  color: completed
                      ? Colors.black
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: completed
                  ? const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 14,
                    )
                  : null,
            ),
          ),
          title: Text(
            task.title ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              decoration:
                  completed ? TextDecoration.lineThrough : null,
              color: completed ? Colors.green : Colors.black,
            ),
          ),
          subtitle: task.description != null &&
                  task.description!.trim().isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    task.description!,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : null,
          trailing: const Icon(
            Icons.drag_handle,
            color: Color(0xFFCCCCCC),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    String message,
    IconData icon,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 60,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (tasks.isEmpty) {
      return _buildEmptyState(
        _tabController.index == 0
            ? 'No pending tasks.\nTap + to add one!'
            : 'Nothing completed yet.',
        _tabController.index == 0
            ? Icons.checklist
            : Icons.task_alt,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (_, index) {
        return _buildTaskCard(tasks[index]);
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,

      drawer: const AppSidebar(),

      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.grid_view_rounded,
            size: 28,
            color: _kTextSub,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          'Tasks',
          style: TextStyle(
            color: _kTextSub,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: _kTextSub,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              text: 'Pending (${_pendingTasks.length})',
            ),
            Tab(
              text: 'Done (${_completedTasks.length})',
            ),
          ],
          onTap: (_) {
            if (mounted) {
              setState(() {});
            }
          },
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(_pendingTasks),
          _buildTaskList(_completedTasks),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _showAddTaskSheet,
        backgroundColor: Colors.black,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          'New Task',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}