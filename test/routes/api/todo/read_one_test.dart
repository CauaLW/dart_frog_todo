import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../core/datasource/todos_data_source.dart';
import '../../../../routes/api/todo/[id].dart' as route;
import '../../../mocks/in_memory_todo_data_set_mock.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequestObject extends Mock implements Request {}

final _datasource = InMemoryTodosDataSourceMock();

void main() {
  final context = _MockRequestContext();
  final request = _MockRequestObject();

  when(() => context.read<TodosDataSource>()).thenReturn(_datasource);
  when(() => context.request).thenReturn(request);

  const itemId = 'mock_A';

  group('GET api/todo/[id]', () {
    setUp(() {
      when(() => request.method).thenReturn(HttpMethod.get);
    });

    group('with existent id', () {
      test('responds with a 200 and return the item', () async {
        final response = await route.onRequest(context, itemId);

        final datasourceItem = await _datasource.read(itemId);

        final responseData = await response.json() as Map<String, dynamic>;
        final responseItem = responseData['item'] as Map<String, dynamic>;

        expect(response.statusCode, equals(HttpStatus.ok));
        expect(responseItem['description'], equals(datasourceItem!.description));
        expect(responseItem['completed'], equals(datasourceItem.completed));
      });
    });

    group('with inexistent id', () {
      test('responds with a not found status', () async {
        final response = await route.onRequest(context, 'INEXISTENT_ID');

        expect(response.statusCode, equals(HttpStatus.notFound));
      });
    });
  });
}
