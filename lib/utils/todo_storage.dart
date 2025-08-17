import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo_model.dart';

class TodoStorage {
  static const String _todoKey ="todos_list";
  Future<List<Todo>> laodTodos() async {
    try{
final prefs = await SharedPreferences.getInstance();
final String? todoJson = prefs.getString(_todoKey);
if(todoJson == null)return [];
final List<dynamic> todosList =json.decode(todoJson);
return todosList.map((json)=> Todo.fromJson(json) ).toList();



    }catch(e){
      return [];
    }
  }

  Future<void> saveTodos(List<Todo> todos) async {

    try{
      final prefs = await SharedPreferences.getInstance();
      final String todoJson = json.encode((todos.map((todo)=> todo.toJson()).toList()));
    await prefs.setString(_todoKey,todoJson);
    }catch(e){
      return print(e);
    }
  }
}