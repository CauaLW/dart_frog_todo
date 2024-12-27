class Todo {
  Todo({
    required this.description,
    required this.completed,
    this.id,
  });

  Todo.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    description = json['description'] as String;
    completed = json['completed'] != null ? json['completed'] as bool : false;
  }

  late final String? id;
  late final String description;
  late final bool completed;

  Todo copyWith({
    String? id,
    String? description,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }

  Todo copyWithJson(Map<String, dynamic> json) {
    return Todo(
      id: (json['id'] ?? id) as String?,
      description: (json['description'] ?? description) as String,
      completed: (json['completed'] ?? completed) as bool,
    );
  }

  Map<String, dynamic> get object {
    return {
      'id': id,
      'description': description,
      'completed': completed,
    };
  }

  @override
  String toString() {
    return '$id, $description, $completed';
  }
}
