import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:jinja/jinja.dart';
import 'package:jinja/loaders.dart';

import '../core/datasource/database_data_source.dart';
import '../core/datasource/in_memory_todo_data_source.dart';
import '../core/datasource/todos_data_source.dart';

final _environment = Environment(
  loader: FileSystemLoader(
    paths: [
      'public/templates',
    ],
  ),
);

final _memoryDatasource = InMemoryTodosDataSource();
final _databaseDatasource = DatabaseDataSource();
final _env = DotEnv()..load();

Handler middleware(Handler handler) {
  final usePostgres = _env.getOrElse('USE_POSTGRES', () => 'false');
  final dataSource = bool.parse(usePostgres) ? _databaseDatasource : _memoryDatasource;

  return handler
    .use(provider<Environment>((_) => _environment))
    .use(provider<TodosDataSource>((_) => dataSource));
}
