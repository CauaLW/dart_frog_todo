import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

import '../models/todo.dart';
import 'todos_data_source.dart';

class DatabaseDataSource implements TodosDataSource {
  final DotEnv _env = DotEnv()..load();
  Connection? _connection;

  @override
  Future<Todo> create(Todo todo) async {
    final db = await _getConnection();

    final id = const Uuid().v4();
    final createdTodo = todo.copyWith(id: id);

    await db.execute(
      Sql.named('INSERT INTO LIST_ITEM (id, description, completed) VALUES (@id, @description, @completed)'),
      parameters: {
        'id': createdTodo.id,
        'description': createdTodo.description,
        'completed': createdTodo.completed,
      },
    );

    return createdTodo;
  }

  @override
  Future<void> delete(String id) async {
    final db = await _getConnection();

    await db.execute(
      Sql.named('DELETE FROM LIST_ITEM WHERE id=@id'),
      parameters: {'id': id},
    );
  }

  @override
  Future<Todo?> read(String id) async {
    final db = await _getConnection();

    final result = await db.execute(
      Sql.named('SELECT * FROM LIST_ITEM WHERE id=@id LIMIT 1'),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    return Todo.fromJson(result.first.toColumnMap());
  }

  @override
  Future<List<Todo>> readAll() async {
    final db = await _getConnection();

    final result = await db.execute('SELECT * FROM LIST_ITEM ORDER BY id');
    final todos = result.map((row) {
      final mappedRow = row.toColumnMap();
      return Todo.fromJson(mappedRow);
    }).toList();

    return todos;
  }

  @override
  Future<Todo> update(String id, Todo todo) async {
    final db = await _getConnection();

    await db.execute(
      Sql.named('UPDATE LIST_ITEM SET description = @description, completed = @completed WHERE id = @id'),
      parameters: {
        'id': todo.id,
        'description': todo.description,
        'completed': todo.completed,
      },
    );

    return todo;
  }

  Future<Connection> _getConnection() async {
    _connection ??= await Connection.open(
      Endpoint(
        host: _env.getOrElse('DB_HOST', () => ''),
        database: _env.getOrElse('DB_NAME', () => ''),
        username: _env.getOrElse('DB_USER', () => ''),
        password: _env.getOrElse('DB_PASSWORD', () => ''),
      ),
    );

    return _connection!;
  }
}
