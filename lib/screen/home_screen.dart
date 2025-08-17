import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../models/todo_model.dart';
import '../provider/todo_provider.dart';
import '../widgets/todo_item.dart';
import '../widgets/todo_stats.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
@override
void dispose() {
  _searchController.dispose();
  // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search todos...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: _searchController,
                onChanged: (value){
                  context.read<TodoProvider>().setSearchQuery(value);
                },
              ),

              Row(children: [
                Consumer<TodoProvider>(builder: (BuildContext context, TodoProvider todoProvider, Widget? child) {
                  return DropdownButton<TodoPriority>(
                    value: todoProvider.filterPriority,
                    hint: Text("Filter By Priority"),
                    items:[...TodoPriority.values.map((priority)=>DropdownMenuItem(child:Text(priority.name.toUpperCase()) ,value: priority, )) ],
                    onChanged: (TodoPriority? value){
                      todoProvider.setFilterPriority(value);
                    },
                  );
                },

                ), Spacer(),

                Consumer<TodoProvider>(builder: (BuildContext context, TodoProvider todoProvider, Widget? child) {
                  return FilterChip(
                    selected: todoProvider.showCompletedOnly,
                    label: Text("Completed Only"),
                    onSelected: (selected){
                     todoProvider.toggleShowCompletedOnly();
                    },
                  );
                },)
              ],)
            ],),
          ),
        ),
        actions:[   PopupMenuButton<String>(
          onSelected: (value) {
            final provider = context.read<TodoProvider>();
            switch (value) {
              case 'clear_filters':
                provider.clearFilter();
                _searchController.clear();
                break;
              case 'delete_completed':
                provider.deleteComplete();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'clear_filters', child: Text('Clear Filters')),
            PopupMenuItem(value: 'delete_completed', child: Text('Delete Completed')),
          ],
        ),
        ],
      ),
body: Column(children: [
  TodoStats(),
  Expanded(
    child: Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        if (todoProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        final todos = todoProvider.todos;

        if (todos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey),
                Text('No todos found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                if (todoProvider.searchQuery.isNotEmpty)
                  Text('Try adjusting your search', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return TodoItem(todo: todos[index]);
          },
        );
      },
    ),
  ),
],
),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}