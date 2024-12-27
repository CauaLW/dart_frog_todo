import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jinja/jinja.dart';

import '../../../core/datasource/todos_data_source.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final environment = context.read<Environment>();
  final dataSource = context.read<TodosDataSource>();

  try {
    await dataSource.delete(
      id,
    );
    return Response(
      statusCode: HttpStatus.found,
      headers: {'Location': '/'},
    );
  } catch (e) {
    final template = environment.getTemplate('todo/index.html');

    final items = await dataSource.readAll();

    return Response(
      body: template.render(
        {
          'error': 'An error occurred, please try again.',
          'items': items.map((i) => i.object),
        },
      ),
      headers: {
        'Content-Type': 'text/html',
      },
    );
  }
}
