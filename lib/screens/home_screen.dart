import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
    setState(() {});
  }

  void _toggleDone(int index) {
    final todo = _todoBox.getAt(index);
    if (todo != null) {
      todo.isDone = !todo.isDone;
      todo.save();
      setState(() {});
    }
  }

  void _deleteTask(int index) {
    _todoBox.deleteAt(index);
    setState(() {});
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: _searchQuery);
        return AlertDialog(
          title: const Text('Tìm kiếm task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Nhập từ khoá...'),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _todoBox.values.toList();
    final filteredTasks = _searchQuery.isEmpty
        ? tasks
        : tasks.where((todo) {
            return todo.title.toLowerCase().contains(_searchQuery) ||
                todo.description.toLowerCase().contains(_searchQuery);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello 👋', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 115, 190, 251),
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
          ? const Center(child: Text('No tasks found'))
          : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final todo = filteredTasks[index];
                final todoIndex = tasks.indexOf(todo); // dùng index thật trong Hive

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
                            todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
                            color: todo.isDone ? Colors.green : null,
                          ),
                          onPressed: () => _toggleDone(todoIndex),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(todoIndex),
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
  }
}
