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

  group('PUT api/todo/[id]', () {
    setUp(() {
      when(() => request.method).thenReturn(HttpMethod.put);
    });

    group('when id is inexistent', () {
      test('responds with a not found status', () async {
        final response = await route.onRequest(context, 'inexistent_id');

        expect(response.statusCode, equals(HttpStatus.notFound));
      });
    });

    group('with invalid data', () {
      test('Returns an internal error status', () async {
        final response = await route.onRequest(context, itemId);

        expect(response.statusCode, equals(HttpStatus.internalServerError));
      });
    });

    group('with valid data', () {
      setUp(() {
        when(request.json).thenAnswer(
          (_) => Future(
            () => {'description': 'UPDATED_DESCRIPTION', 'completed': false},
          ),
        );
      });
      test('responds with a 200 and update the item', () async {
        final response = await route.onRequest(context, itemId);

        final item = await _datasource.read(itemId);

        expect(response.statusCode, equals(HttpStatus.ok));
        expect(item!.description, equals('UPDATED_DESCRIPTION'));
        expect(item.completed, equals(false));
      });
    });
  });
}
