import 'package:uuid/uuid.dart';

import '../../core/datasource/todos_data_source.dart';
import '../../core/models/todo.dart';

/// An in-memory mock implementation of the [TodosDataSource] interface.
class InMemoryTodosDataSourceMock implements TodosDataSource {
  /// Map of ID -> Todo
  final _cache = <String, Todo>{
    'mock_A': Todo(id: 'mock_A', description: 'Item 1 (complete)', completed: true),
    'mock_B': Todo(id: 'mock_B', description: 'Item 2 (incomplete)', completed: false),
  };

  @override
  Future<Todo> create(Todo todo) async {
    final id = const Uuid().v4();
    final createdTodo = todo.copyWith(id: id);
    _cache[id] = createdTodo;
    return createdTodo;
  }

  @override
  Future<List<Todo>> readAll() async => _cache.values.toList();

  @override
  Future<Todo?> read(String id) async => _cache[id];

  @override
  Future<Todo> update(String id, Todo todo) async {
    return _cache.update(id, (value) => todo);
  }

  @override
  Future<void> delete(String id) async => _cache.remove(id);
}
