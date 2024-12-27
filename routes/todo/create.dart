import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jinja/jinja.dart';

import '../../core/datasource/todos_data_source.dart';
import '../../core/models/todo.dart';

Future<Response> onRequest(RequestContext context) async {
  final request = context.request;
  final method = request.method;

  switch (method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    // ignore: no_default_cases
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Response _get(RequestContext context) {
  final environment = context.read<Environment>();

  final template = environment.getTemplate('todo/create.html');

  return Response(
    body: template.render(),
    headers: {
      'Content-Type': 'text/html',
    },
  );
}

Future<Response> _post(RequestContext context) async {
  final request = context.request;

  final environment = context.read<Environment>();
  final dataSource = context.read<TodosDataSource>();

  try {
    final formData = await request.formData();
    final formFields = formData.fields;

    await dataSource.create(
      Todo(
        description: formFields['description']!,
        completed: false,
      ),
    );
    return Response(
      statusCode: HttpStatus.found,
      headers: {'Location': '/'},
    );
  } catch (e) {
    final template = environment.getTemplate('todo/create.html');

    return Response(
      statusCode: HttpStatus.badRequest,
      body: template.render(
        {'error': 'An error occurred, please try again.'},
      ),
      headers: {
        'Content-Type': 'text/html',
      },
    );
  }
}
