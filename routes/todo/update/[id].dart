import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jinja/jinja.dart';

import '../../../core/datasource/todos_data_source.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final request = context.request;
  final environment = context.read<Environment>();
  final dataSource = context.read<TodosDataSource>();

  try {
    final formData = await request.formData();
    final formFields = formData.fields;

    final actualTodo = await dataSource.read(id);

    await dataSource.update(
      id,
      actualTodo!.copyWith(
        description: formFields['description'],
        completed: formFields['completed'] != null ? bool.parse(formFields['completed']!) : null,
      ),
    );
    return Response(
      statusCode: HttpStatus.found,
      headers: {'Location': '/'},
    );
  } catch (e) {
    final template = environment.getTemplate('todo/index.html');

    final items = await dataSource.readAll();

    return Response(
      statusCode: HttpStatus.badRequest,
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
