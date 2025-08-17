import "dart:convert";
enum TodoPriority { low ,medium,high }
class Todo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;
  final TodoPriority priority;

  Todo(
  {required this.id,required this.title, this.description="", this.isCompleted=false,required this.createdAt, this.completedAt, this.priority =TodoPriority.medium});


  Todo copyWith({
   String? id,
 String? title,
  String? description,
  bool? isCompleted,
  DateTime? createdAt,
   DateTime? completedAt,
   TodoPriority? priority,
  }){
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ??this.completedAt,
      priority: priority ?? this.priority,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'priority': priority.index,
    };
  }
factory Todo.fromJson(Map<String , dynamic> json){
return Todo(
id: json["id"],
  title: json["title"],
  description: json["description"]??'',
  isCompleted: json["isCompleted"]??false,
  createdAt:DateTime.fromMillisecondsSinceEpoch( json["createdAt"]) ,
  completedAt: json["completedAt"]!=null ?
  DateTime.fromMillisecondsSinceEpoch(json["completedAt"]):null ,
  priority: TodoPriority.values[json['priority'] ?? 1],
  );

  }
}