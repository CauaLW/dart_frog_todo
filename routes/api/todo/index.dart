import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../core/datasource/todos_data_source.dart';
import '../../../core/models/todo.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    // ignore: no_default_cases
    default:
      return Response(
        statusCode: HttpStatus.methodNotAllowed,
      );
  }
}

Future<Response> _get(RequestContext context) async {
  try {
    final dataSource = context.read<TodosDataSource>();

    final items = await dataSource.readAll();

    return Response.json(
      body: {
        'items': items.map((i) => i.object).toList(),
      },
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
    );
  }
}

Future<Response> _post(RequestContext context) async {
  try {
    final request = context.request;

    final dataSource = context.read<TodosDataSource>();

    final data = await request.json() as Map<String, dynamic>;

    await dataSource.create(Todo.fromJson(data));

    return Response();
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
    );
  }
}
