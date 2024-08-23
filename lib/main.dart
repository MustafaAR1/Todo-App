import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/Auth/auth_controller.dart';
import 'package:todo_app/Auth/views/login_view.dart';
import 'package:todo_app/controllers/network_controller.dart';
import 'package:todo_app/posts/controllers/post_controller.dart';
import 'package:todo_app/posts/views/post_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  _initControllers();

  runApp(const MyApp());
}

_initControllers() {
  Get
    ..put(NetworkController())
    ..put(AuthController())
    ..put(PostController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const LoginView(),
    );
  }
}
