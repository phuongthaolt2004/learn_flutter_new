import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Todo> _todoBox;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _todoBox = Hive.box<Todo>('todos');
  }

  void _addNewTask(Todo todo) {
    _todoBox.add(todo);
  }

  void _toggleDone(int index) {
    final todo = _todoBox.getAt(index);
    if (todo != null) {
      todo.isDone = !todo.isDone;
      todo.save();
    }
  }

  void _deleteTask(int index) {
    _todoBox.deleteAt(index);
  }

  void _showSearchDialog() {
    final controller = TextEditingController(text: _searchQuery);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tìm kiếm task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nhập từ khoá...'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
              Navigator.pop(context);
            },
            child: const Text('Xoá lọc'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = controller.text.toLowerCase();
              });
              Navigator.pop(context);
            },
            child: const Text('Tìm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Todo>>(
      valueListenable: _todoBox.listenable(),
      builder: (context, box, _) {
        final allTasks = box.values.toList();
        final filteredTasks = _searchQuery.isEmpty
            ? allTasks
            : allTasks.where((todo) {
                return todo.title.toLowerCase().contains(_searchQuery) ||
                       todo.description.toLowerCase().contains(_searchQuery);
              }).toList();
              

        return Scaffold(
          appBar: AppBar(
            title: const Text('Danh sách công việc'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _showSearchDialog,
              ),
              const SizedBox(width: 12),
              const Icon(Icons.notifications_none),
              const SizedBox(width: 12),
            ],
          ),
          body: filteredTasks.isEmpty
              ? const Center(child: Text('Không có công việc nào'))
              : ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final todo = filteredTasks[index];
                    final realIndex = allTasks.indexOf(todo); // Lấy index thực trong Hive

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(todo.title),
                        subtitle: Text(
                          '${todo.description}\n${todo.deadline.toLocal()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                todo.isDone
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: todo.isDone ? Colors.green : null,
                              ),
                              onPressed: () => _toggleDone(realIndex),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(realIndex),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            onTap: (i) {
              if (i == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddTaskScreen(onAdd: _addNewTask),
                  ),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add task'),
              BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Task'),
            ],
          ),
        );
      },
    );
  }
}
