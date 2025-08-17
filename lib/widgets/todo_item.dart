// widgets/todo_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../provider/todo_provider.dart';
import '../screen/add_todo_screen.dart';
import '../screen/todo_details_screen.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: ListTile(
        key: ValueKey(todo.id),

        // Checkbox
        leading: Consumer<TodoProvider>(
          builder: (context, todoProvider, child) {
            return Checkbox(
              value: todo.isCompleted,
              onChanged: (bool? value) {
                context.read<TodoProvider>().toggleTodo(todo.id);
              },
              activeColor: Colors.green,
            );
          },
        ),

        // Title & Subtitle with proper constraints
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : null,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis, // ✅ Fix text overflow
          maxLines: 1, // ✅ Limit title to 1 line
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // ✅ Prevent vertical expansion
          children: [
            if (todo.description.isNotEmpty) ...[
              SizedBox(height: 4), // ✅ Controlled spacing
              Text(
                todo.description,
                style: TextStyle(
                  color: todo.isCompleted ? Colors.grey : Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            SizedBox(height: 4), // ✅ Controlled spacing
            Row(
              mainAxisSize: MainAxisSize.min, // ✅ Prevent horizontal expansion
              children: [
                _buildPriorityChip(todo.priority),
                SizedBox(width: 8),
                Text(
                  _formatDate(todo.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),

        // ✅ Compact trailing with popup menu
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.grey),
          onSelected: (value) {
            switch (value) {
              case 'view':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoDetailScreen(todo: todo),
                  ),
                );
                break;
              case 'edit':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTodoScreen(todo: todo),
                  ),
                );
                break;
              case 'delete':
                _showDeleteDialog(context);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Text('Edit Todo'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('Delete Todo'),
                ],
              ),
            ),
          ],
        ),

        // Tap to view details
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoDetailScreen(todo: todo),
            ),
          );
        },

        // ✅ Prevent excessive height
        dense: true,
        isThreeLine: false,
      ),
    );
  }

  Widget _buildPriorityChip(TodoPriority priority) {
    Color color;
    switch (priority) {
      case TodoPriority.high:
        color = Colors.red;
        break;
      case TodoPriority.medium:
        color = Colors.orange;
        break;
      case TodoPriority.low:
        color = Colors.green;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), // ✅ Smaller padding
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8), // ✅ Smaller radius
      ),
      child: Text(
        priority.name.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 9, // ✅ Smaller font
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Todo'),
          content: Text('Are you sure you want to delete "${todo.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<TodoProvider>().deleteTodo(todo.id);
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
