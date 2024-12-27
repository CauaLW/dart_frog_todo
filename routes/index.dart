import 'package:dart_frog/dart_frog.dart';
import 'package:jinja/jinja.dart';

import '../core/datasource/todos_data_source.dart';

Future<Response> onRequest(RequestContext context) async {
  final environment = context.read<Environment>();
  final dataSource = context.read<TodosDataSource>();

  final template = environment.getTemplate('todo/index.html');
  final items = await dataSource.readAll();

  return Response(
    body: template.render({
      'items': items.map((i) => i.object),
    }),
    headers: {
      'Content-Type': 'text/html',
    },
  );
}
