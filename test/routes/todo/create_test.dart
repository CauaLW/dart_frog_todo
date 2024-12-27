import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jinja/jinja.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../core/datasource/todos_data_source.dart';
import '../../../routes/todo/create.dart' as route;
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

  group('GET todo/create', () {
    setUp(() {
      when(() => request.method).thenReturn(HttpMethod.get);
    });

    test('responds with a 200', () async {
      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
    });
    test('render the description input', () async {
      final response = await route.onRequest(context);

      expect(
        response.body(),
        completion(contains('required name="description" id="description-input"')),
      );
    });
  });

  group('POST todo/create', () {
    setUp(() {
      when(() => request.method).thenReturn(HttpMethod.post);
    });

    group('with valid data', () {
      const formData = FormData(
        fields: {
          'description': 'TEST INSERT',
        },
        files: {},
      );

      setUp(() {
        when(request.formData).thenAnswer((_) => Future(() => formData));
      });

      test('responds with a found response', () async {
        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.found));
      });
      test('insert the new item', () async {
        await route.onRequest(context);

        final items = await _datasource.readAll();
        final createdIndex = items.indexWhere((item) => item.description == 'TEST INSERT');
        expect(createdIndex, isNot(-1));
      });
    });

    group('with invalid data', () {
      const formData = FormData(
        fields: {},
        files: {},
      );

      setUp(() {
        when(request.formData).thenAnswer((_) => Future(() => formData));
      });

      test('responds with a badRequest response', () async {
        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.badRequest));
        expect(
          response.body(),
          completion(contains('An error occurred, please try again.')),
        );
      });
    });
  });
}
