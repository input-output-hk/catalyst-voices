import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:dio/dio.dart';

ApiException _mapDioException(DioException exception) {
  final requestOptions = exception.requestOptions;
  final uri = requestOptions.uri;
  final message = exception.message;
  final error = exception.error;
  final response = exception.response;

  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
      return ApiConnectionTimeoutException(
        message: message,
        uri: uri,
        error: error,
        duration: requestOptions.connectTimeout,
      );
    case DioExceptionType.sendTimeout:
      return ApiSendTimeoutException(
        message: message,
        uri: uri,
        error: error,
        duration: requestOptions.sendTimeout,
      );
    case DioExceptionType.receiveTimeout:
      return ApiReceiveTimeoutException(
        message: message,
        uri: uri,
        error: error,
        duration: requestOptions.receiveTimeout,
      );
    case DioExceptionType.badCertificate:
      return ApiBadCertificateException(
        message: message,
        uri: uri,
        error: error,
      );
    case DioExceptionType.badResponse:
      return ApiBadResponseException(
        message: message,
        uri: uri,
        error: error,
        statusCode: response?.statusCode ?? ApiResponseStatusCode.badRequest,
        responseBody: response?.data,
      );
    case DioExceptionType.cancel:
      return ApiRequestCancelledException(
        message: message,
        uri: uri,
        error: error,
      );
    case DioExceptionType.connectionError:
      return ApiConnectionErrorException(
        message: message,
        uri: uri,
        error: error,
      );
    case DioExceptionType.unknown:
      return ApiUnknownException(
        message: message,
        uri: uri,
        error: error,
      );
  }
}

typedef Mapper<R, T> = T Function(R response);

abstract interface class DioClient {
  factory DioClient(Dio dio) = DioClientImpl;

  void close();

  Future<T> delete<R, T>(
    String urlPath, {
    required Mapper<R, T> mapper,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<T> download<T>(
    String urlPath, {
    required String savePath,
    required Mapper<dynamic, T> mapper,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool deleteOnError,
    String lengthHeader,
  });

  Future<T> get<R, T>(
    String urlPath, {
    required Mapper<R, T> mapper,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  });

  Future<T> head<R, T>(
    String urlPath, {
    required Mapper<R, T> mapper,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<T> patch<R, T>(
    String urlPath, {
    required Mapper<R, T> mapper,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
  });

  Future<T> post<R, T>(
    String urlPath, {
    required Mapper<R, T> mapper,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  });

  Future<T> put<R, T>(
    String urlPath, {
    required Mapper<R, T> mapper,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
  });
}

final class DioClientImpl implements DioClient {
  final Dio _dio;

  const DioClientImpl(this._dio);

  @override
  void close() => _dio.close();

  @override
  Future<T> delete<R, T>(
    String urlPath, {
    required Mapper<R, T> mapper,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request(
      urlPath: urlPath,
      mapper: mapper,
      method: _RequestMethod.delete,
      queryParameters: queryParameters,
      body: body,
      options: options,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<T> download<T>(
    String urlPath, {
    required String savePath,
    required Mapper<dynamic, T> mapper,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
  }) async {
    final requestOptions = (options ?? Options()).copyWith(
      method: _RequestMethod.get.name.toUpperCase(),
    );

    try {
      final response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: body,
        options: requestOptions,
      );
      return mapper(response.data);
    } on DioException catch (error, stackTrace) {
      Error.throwWithStackTrace(_mapDioException(error), stackTrace);
    }
  }

  @override
  Future<T> get<R, T>(
    String urlPath, {
    required Mapper<R, T> mapper,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _request(
      urlPath: urlPath,
      mapper: mapper,
      method: _RequestMethod.get,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<T> head<R, T>(
    String urlPath, {
    required Mapper<R, T> mapper,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request(
      urlPath: urlPath,
      mapper: mapper,
      method: _RequestMethod.head,
      queryParameters: queryParameters,
      body: body,
      options: options,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<T> patch<R, T>(
    String urlPath, {
    required Mapper<R, T> mapper,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request(
      urlPath: urlPath,
      mapper: mapper,
      method: _RequestMethod.patch,
      queryParameters: queryParameters,
      body: body,
      options: options,
      cancelToken: cancelToken,
    );
  }

  @override
  Future<T> post<R, T>(
    String urlPath, {
    required Mapper<R, T> mapper,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) {
    return _request(
      urlPath: urlPath,
      mapper: mapper,
      method: _RequestMethod.post,
      queryParameters: queryParameters,
      body: body,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  @override
  Future<T> put<R, T>(
    String urlPath, {
    required Mapper<R, T> mapper,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request(
      urlPath: urlPath,
      mapper: mapper,
      method: _RequestMethod.put,
      queryParameters: queryParameters,
      body: body,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<T> _request<R, T>({
    required String urlPath,
    required Mapper<R, T> mapper,
    required _RequestMethod method,
    Map<String, dynamic>? queryParameters,
    Object? body,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final requestOptions = (options ?? Options()).copyWith(
      method: method.name.toUpperCase(),
    );

    try {
      final response = await _dio.request<R>(
        urlPath,
        queryParameters: queryParameters,
        data: body,
        options: requestOptions,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return mapper(response.data as R);
    } on DioException catch (error, stackTrace) {
      Error.throwWithStackTrace(_mapDioException(error), stackTrace);
    }
  }
}

enum _RequestMethod { post, get, put, patch, head, delete }
