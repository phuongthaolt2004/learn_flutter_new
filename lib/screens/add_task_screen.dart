import 'package:flutter/material.dart';
import '../models/todo.dart';

class AddTaskScreen extends StatefulWidget {
  final void Function(Todo) onAdd;

  const AddTaskScreen({super.key, required this.onAdd});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_checkIfInputIsValid);
    _descController.addListener(_checkIfInputIsValid);
  }

  void _checkIfInputIsValid() {
    setState(() {
      isButtonEnabled =
          _titleController.text.trim().isNotEmpty &&
          _descController.text.trim().isNotEmpty;
    });
  }

  void _submit() {
    if (!isButtonEnabled) return;

    final newTodo = Todo(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      deadline: _selectedDate,
    );

    widget.onAdd(newTodo);
    Navigator.pop(context);
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm công việc')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tiêu đề'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('Deadline: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                const Spacer(),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Chọn ngày'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isButtonEnabled ? _submit : null,
              child: const Text('Thêm công việc'),
            ),
          ],
        ),
      ),
    );
  }
}
