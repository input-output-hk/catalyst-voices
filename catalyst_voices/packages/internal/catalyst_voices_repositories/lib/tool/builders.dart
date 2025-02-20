library builders;

import 'package:build/build.dart';

import 'openapi_pre_process_builder.dart';

Builder openApiPreProcessBuilder(BuilderOptions options) =>
    OpenApiPreProcessBuilder(options);
