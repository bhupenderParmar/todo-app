// widgets/todo_stats.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/todo_provider.dart';

class TodoStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Total',
                todoProvider.totalTodos.toString(),
                Icons.list,
                Colors.blue,
              ),
              _buildStatItem(
                'Completed',
                todoProvider.completedTodos.toString(),
                Icons.check_circle,
                Colors.green,
              ),
              _buildStatItem(
                'Pending',
                todoProvider.pendingTodos.toString(),
                Icons.pending,
                Colors.orange,
              ),
              _buildStatItem(
                'Progress',
                '${todoProvider.completionPercentage.toStringAsFixed(0)}%',
                Icons.trending_up,
                Colors.purple,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
