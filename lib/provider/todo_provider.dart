

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/todo_model.dart';
import '../utils/todo_storage.dart';

class TodoProvider with ChangeNotifier {
  final TodoStorage _storage = TodoStorage();
final Uuid _uuid =Uuid();
List<Todo> _todos =[];
bool _isLoading =false;
String _searchQuery ='';
TodoPriority? _filterPriority;
bool _showCompletedOnly =false;
List<Todo> get todos => _getFilteredTodos();
List<Todo> get allTodos =>[..._todos ];
bool get isLoading =>_isLoading;
String get searchQuery => _searchQuery;
TodoPriority? get filterPriority => _filterPriority;
bool get showCompletedOnly => _showCompletedOnly;
int get totalTodos => _todos.length;
int get completedTodos => _todos.where((todo)=>todo.isCompleted ).length;
int get pendingTodos => _todos.where((todo)=> !todo.isCompleted).length;
double get completionPercentage => totalTodos > 0 ? (completedTodos / totalTodos)*100:0;
Future<void> loadTodos() async {
  _setLoading(true);
  try{
    _todos = await _storage.laodTodos();
    notifyListeners();

  }catch (e){
    debugPrint("Error loading todos: $e");
  }finally{
    _setLoading(false);
  }
}
Future<void> addTodo(String title,String description, TodoPriority priority)
  async {
  final newTodo = Todo(
    id: _uuid.v4(),
    title: title,
    description: description,
    createdAt: DateTime.now(),
    priority: priority,
  );
  _todos.add(newTodo);
  await _saveTodos();
  notifyListeners();
  }

  // In TodoProvider toggleTodo method
  Future<void> toggleTodo(String id) async {
    print('Toggle called for ID: $id'); // Debug
    final index = _todos.indexWhere((todo) => todo.id == id);
    print('Found todo at index: $index'); // Debug

    if (index != -1) {
      final todo = _todos[index];
      print('Before toggle: ${todo.isCompleted}'); // Debug

      _todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);

      print('After toggle: ${_todos[index].isCompleted}'); // Debug
      print('Calling notifyListeners()'); // Debug

      await _saveTodos();
      notifyListeners();
    }
  }

  Future<void> updateTodo(String id, String title, String description, TodoPriority priority) async {
    print('Updating todo with ID: $id'); // Debug
    final index = _todos.indexWhere((todo) => todo.id == id);
    print('Found todo at index: $index'); // Debug

    if(index != -1){  // ✅ CORRECT CONDITION
      print('Before update: ${_todos[index].title}'); // Debug

      _todos[index] = _todos[index].copyWith(
        title: title,
        description: description,
        priority: priority,
      );

      print('After update: ${_todos[index].title}'); // Debug

      await _saveTodos();
      notifyListeners();
      print('Update completed!'); // Debug
    } else {
      print('Todo not found with ID: $id'); // Debug
    }
  }


  Future<void> deleteTodo( String id) async {
   _todos.removeWhere((todo) => todo.id==id);
await _saveTodos();
notifyListeners();
}
Future<void> deleteComplete( ) async{
  _todos.removeWhere((todo)=>todo.isCompleted);
await _saveTodos();
notifyListeners();
}
void setSearchQuery(String query){
  _searchQuery =query;
notifyListeners();
}
void setFilterPriority(TodoPriority? priority){
  _filterPriority = priority;
  notifyListeners();
}
void toggleShowCompletedOnly(){
  _showCompletedOnly = !_showCompletedOnly;
  notifyListeners();
}
void clearFilter(){
  _searchQuery ="";
  _showCompletedOnly =false;
  _filterPriority = null;
  notifyListeners();
}
void _setLoading(bool loading){
  _isLoading =loading;
  notifyListeners();
}
Future<void> _saveTodos() async{
  await _storage.saveTodos(_todos);
}
  List<Todo> _getFilteredTodos() {
    List<Todo> filtered = [..._todos];

    // Search filter
    if(_searchQuery.isNotEmpty){
      filtered = filtered.where((todo) =>
      todo.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          todo.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // ✅ PRIORITY FILTER - This was missing!
    if(_filterPriority != null){
      filtered = filtered.where((todo) => todo.priority == _filterPriority).toList();
    }

    // Completed filter
    if(_showCompletedOnly){
      filtered = filtered.where((todo) => todo.isCompleted).toList();
    }

    // Sort by creation date (newest first)
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filtered;
  }

}