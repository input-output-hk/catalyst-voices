library builders;

import 'package:build/build.dart';
import 'package:catalyst_voices_repositories/builders/openapi_pre_process_builder.dart';

/// Creates an OpenAPI pre-processor builder
Builder openApiPreProcessBuilder(BuilderOptions options) =>
    OpenApiPreProcessBuilder(options);
