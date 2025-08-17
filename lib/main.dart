import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'provider/todo_provider.dart';
import 'screen/home_screen.dart';

void main(){
  runApp(TodoApp());
}
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>TodoProvider()..loadTodos(),

      child:MaterialApp(
        title: "Todo App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ) ,
    );
  }
}
