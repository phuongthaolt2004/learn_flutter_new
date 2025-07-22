import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/screens/welcome_screen.dart';
import 'models/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Đăng ký adapter nếu bạn dùng Hive Type
  Hive.registerAdapter(TodoAdapter());

  // Mở box trước khi chạy app
  await Hive.openBox<Todo>('todos');
  await Hive.openBox('settings'); // nếu có settings

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box('settings');

    return ValueListenableBuilder(
      valueListenable: settingsBox.listenable(),
      builder: (context, box, _) {
        return MaterialApp(
          title: 'Your App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
