import 'package:jinja/jinja.dart';
import 'package:jinja/loaders.dart';

final environmentMock = Environment(
  loader: FileSystemLoader(
    paths: [
      'public/templates',
    ],
  ),
);
