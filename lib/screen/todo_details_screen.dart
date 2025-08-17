// screens/todo_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../provider/todo_provider.dart';
import 'add_todo_screen.dart';

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;

  const TodoDetailScreen({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Quick Edit button in AppBar
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTodoScreen(todo: todo),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          // Get latest todo data
          final currentTodos = todoProvider.allTodos;
          final currentTodo = currentTodos.firstWhere(
                (t) => t.id == todo.id,
            orElse: () => todo,
          );

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Card
                Card(
                  color: currentTodo.isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          currentTodo.isCompleted ? Icons.check_circle : Icons.pending,
                          color: currentTodo.isCompleted ? Colors.green : Colors.orange,
                          size: 32,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            currentTodo.isCompleted ? 'Completed' : 'Pending',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: currentTodo.isCompleted ? Colors.green : Colors.orange,
                            ),
                          ),
                        ),
                        Switch(
                          value: currentTodo.isCompleted,
                          onChanged: (value) {
                            context.read<TodoProvider>().toggleTodo(currentTodo.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Title
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.title, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Title', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(currentTodo.title, style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),

                // Description
                if (currentTodo.description.isNotEmpty) ...[
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.description, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(currentTodo.description, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                ],

                // Priority
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.flag, color: Colors.purple),
                            SizedBox(width: 8),
                            Text('Priority', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(currentTodo.priority),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            currentTodo.priority.name.toUpperCase(),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),

                // Created Date
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.schedule, color: Colors.teal),
                            SizedBox(width: 8),
                            Text('Created', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(_formatDate(currentTodo.createdAt), style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTodoScreen(todo: currentTodo),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit),
                        label: Text('Edit Todo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<TodoProvider>().toggleTodo(currentTodo.id);
                        },
                        icon: Icon(currentTodo.isCompleted ? Icons.undo : Icons.check),
                        label: Text(currentTodo.isCompleted ? 'Mark Pending' : 'Complete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: currentTodo.isCompleted ? Colors.orange : Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return Colors.red;
      case TodoPriority.medium:
        return Colors.orange;
      case TodoPriority.low:
        return Colors.green;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
