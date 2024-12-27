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

  group('DELETE api/todo/[id]', () {
    setUp(() {
      when(() => request.method).thenReturn(HttpMethod.delete);
    });

    test('responds with a 200 and delete the item', () async {
      final response = await route.onRequest(context, itemId);

      final item = await _datasource.read(itemId);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(item, equals(null));
    });
  });
}
