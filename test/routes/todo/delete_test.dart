import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jinja/jinja.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../core/datasource/todos_data_source.dart';
import '../../../routes/todo/delete/[id].dart' as route;
import '../../mocks/environment_mock.dart';
import '../../mocks/in_memory_todo_data_set_mock.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequestObject extends Mock implements Request {}

final _datasource = InMemoryTodosDataSourceMock();

void main() {
  final context = _MockRequestContext();
  final request = _MockRequestObject();

  when(() => context.read<TodosDataSource>()).thenReturn(_datasource);
  when(() => context.read<Environment>()).thenReturn(environmentMock);
  when(() => context.request).thenReturn(request);

  group('POST todo/delete', () {
    setUp(() {
      when(() => request.method).thenReturn(HttpMethod.post);
    });

    test('responds with a redirect response and delete the item', () async {
      final response = await route.onRequest(context, 'mock_A');

      final deletedTodo = await _datasource.read('mock_A');

      expect(response.statusCode, equals(HttpStatus.found));
      expect(deletedTodo, equals(null));
    });
  });
}
