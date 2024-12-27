import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../core/datasource/todos_data_source.dart';
import '../../../../core/models/todo.dart';
import '../../../../routes/api/todo/index.dart' as route;
import '../../../mocks/in_memory_todo_data_set_mock.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequestObject extends Mock implements Request {}

final _datasource = InMemoryTodosDataSourceMock();

void main() {
  final context = _MockRequestContext();
  final request = _MockRequestObject();

  when(() => context.read<TodosDataSource>()).thenReturn(_datasource);
  when(() => context.request).thenReturn(request);

  group('GET api/todo', () {
    setUp(() {
      when(() => request.method).thenReturn(HttpMethod.get);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
    });
    test('correctly return all items', () async {
      final response = await route.onRequest(context);

      final data = await response.body();

      expect(
        data,
        equals(
          '{"items":[{"id":"mock_A","description":"Item 1 (complete)","completed":true},{"id":"mock_B","description":"Item 2 (incomplete)","completed":false}]}',
        ),
      );
    });
  });

  group('POST api/todo', () {
    setUp(() {
      when(() => request.method).thenReturn(HttpMethod.post);
    });

    group('with valid data', () {
      setUp(() {
        final testTodo = Todo(
          description: 'TEST_ITEM',
          completed: false,
        );

        when(request.json).thenAnswer(
          (_) => Future(
            () => testTodo.object,
          ),
        );
      });

      test('responds with a 200 and create the item', () async {
        final response = await route.onRequest(context);

        final items = await _datasource.readAll();

        expect(response.statusCode, equals(HttpStatus.ok));
        expect(items.indexWhere((i) => i.description == 'TEST_ITEM'), isNot(-1));
      });
    });

    group('with invalid data', () {
      setUp(() {
        when(request.json).thenAnswer(
          (_) => Future(
            () => '{}',
          ),
        );
      });

      test('responds with a 200 and create the item', () async {
        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.internalServerError));
      });
    });

    group('with no data', () {
      setUp(() {
        when(request.json).thenAnswer(
          (_) => Future(
            () => null,
          ),
        );
      });

      test('responds with a 200 and create the item', () async {
        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.internalServerError));
      });
    });
  });
}
