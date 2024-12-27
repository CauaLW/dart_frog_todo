import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../core/datasource/todos_data_source.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, id);
    case HttpMethod.put:
      return _put(context, id);
    case HttpMethod.delete:
      return _delete(context, id);
    // ignore: no_default_cases
    default:
      return Response(
        statusCode: HttpStatus.methodNotAllowed,
      );
  }
}

Future<Response> _get(RequestContext context, String id) async {
  try {
    final dataSource = context.read<TodosDataSource>();

    final item = await dataSource.read(id);

    if (item == null) {
      return Response(
        statusCode: HttpStatus.notFound,
      );
    }

    return Response.json(
      body: {
        'item': item.object,
      },
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
    );
  }
}

Future<Response> _put(RequestContext context, String id) async {
  try {
    final request = context.request;

    final dataSource = context.read<TodosDataSource>();

    final item = await dataSource.read(id);

    if (item == null) {
      return Response(
        statusCode: HttpStatus.notFound,
      );
    }

    final data = await request.json() as Map<String, dynamic>;

    final updatedItem = item.copyWithJson(data);

    await dataSource.update(id, updatedItem);

    return Response.json(
      body: {
        'item': updatedItem.object,
      },
    );
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
    );
  }
}

Future<Response> _delete(RequestContext context, String id) async {
  try {
    final dataSource = context.read<TodosDataSource>();

    await dataSource.delete(id);

    return Response();
  } catch (e) {
    return Response(
      statusCode: HttpStatus.internalServerError,
    );
  }
}
