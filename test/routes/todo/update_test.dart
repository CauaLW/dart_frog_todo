import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jinja/jinja.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../core/datasource/todos_data_source.dart';
import '../../../routes/todo/update/[id].dart' as route;
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

  group('POST todo/update', () {
    setUp(() {
      when(() => request.method).thenReturn(HttpMethod.post);
    });

    group('with valid data', () {
      const formData = FormData(
        fields: {
          'description': 'TEST_UPDATE',
          'completed': 'false',
        },
        files: {},
      );
      setUp(() {
        when(request.formData).thenAnswer((_) => Future(() => formData));
      });
      test('responds with a redirect response and update the data', () async {
        final response = await route.onRequest(context, 'mock_A');

        final updatedTodo = await _datasource.read('mock_A');

        expect(response.statusCode, equals(HttpStatus.found));
        expect(updatedTodo!.description, equals('TEST_UPDATE'));
        expect(updatedTodo.completed, equals(false));
      });
    });

    group('with invalid id', () {
      const formData = FormData(
        fields: {},
        files: {},
      );

      setUp(() {
        when(request.formData).thenAnswer((_) => Future(() => formData));
      });

      test('responds with a badRequest response and renders the error', () async {
        final response = await route.onRequest(context, 'invalid_id');

        expect(response.statusCode, equals(HttpStatus.badRequest));
        expect(
          response.body(),
          completion(contains('An error occurred, please try again.')),
        );
      });
    });
  });
}
