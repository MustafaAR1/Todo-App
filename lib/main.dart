import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/Auth/auth_controller.dart';
import 'package:todo_app/controllers/database_controller.dart';
import 'package:todo_app/controllers/network_controller.dart';
import 'package:todo_app/posts/controllers/post_controller.dart';
import 'package:todo_app/posts/views/post_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _initControllers();
  
    // final _databaseController = Get.find<DatabaseController>();
    // _databaseController.openDatabse();
  

  runApp(const MyApp());
}

void _initControllers() {
  Get
    ..put(DatabaseController())
    ..put(NetworkController())
    ..put(AuthController())
    ..put(PostController());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const PostView(),
    );
  }
}
