import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jinja/jinja.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../core/datasource/todos_data_source.dart';
import '../../routes/index.dart' as route;
import '../mocks/environment_mock.dart';
import '../mocks/in_memory_todo_data_set_mock.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /', () {
    final context = _MockRequestContext();

    when(() => context.read<TodosDataSource>()).thenReturn(InMemoryTodosDataSourceMock());
    when(() => context.read<Environment>()).thenReturn(environmentMock);
    test('responds with a 200', () async {
      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
    });
    test('correctly render items', () async {
      final response = await route.onRequest(context);

      expect(
        response.body(),
        completion(contains('Item 1 (complete)')),
      );
      expect(
        response.body(),
        completion(contains('Item 2 (incomplete)')),
      );
    });
  });
}
