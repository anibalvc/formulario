import 'package:binance_api_test/core/api/core/api_status.dart';
import 'package:binance_api_test/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class Http {
  late Dio _dio;
  late Logger _logger;
  late bool _logsEnabled;
  Http({
    required Dio dio,
    required Logger logger,
    required bool logsEnabled,
  }) {
    _dio = dio;
    _logger = logger;
    _logsEnabled = logsEnabled;
  }

  Future<Object> request<T>(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    T Function(dynamic data)? parser,
  }) async {
    try {
      if (queryParameters != null) {
        queryParameters.removeWhere((key, value) => value == null);
      }
      Logger().d(data);
      final response = await _dio
          .request<Map<String, dynamic>>(
            path,
            options: Options(
              method: method,
              headers: headers,
            ),
            queryParameters: queryParameters,
            data: data,
          )
          .timeout(durationLoading);
      if (_logsEnabled) _logger.i(response.data);
      if (parser != null) {
        return Success<T>(response: parser(response.data));
      }
      return Success(response: response.data!);
    } catch (e) {
      _logger.e(e);
      Failure data = Failure(
        message: 'No Internet',
      );
      if (e is DioError) {
        if (_logsEnabled) _logger.e(e.response?.data ?? 'DioError Null');
        if (e.response?.data != null) {
          try {
            data = Failure.fromJson(e.response?.data);
          } catch (e) {
            data = Failure(
              message: 'Error desconocido',
            );
          }
        }
      }
      return data;
    }
  }

  Future<Object> requestList<T>(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    T Function(dynamic data)? parser,
  }) async {
    try {
      if (queryParameters != null) {
        queryParameters.removeWhere((key, value) => value == null);
      }
      Logger().d(data);
      final response = await _dio
          .request<List<dynamic>>(
            path,
            options: Options(
              method: method,
              headers: headers,
            ),
            queryParameters: queryParameters,
            data: data,
          )
          .timeout(durationLoading);
      if (_logsEnabled) _logger.i(response.data);
      if (parser != null) {
        return Success<T>(response: parser(response.data));
      }
      return Success(response: response.data!);
    } catch (e) {
      _logger.e(e);
      Failure data = Failure(
        message: 'No Internet',
      );
      if (e is DioError) {
        if (_logsEnabled) _logger.e(e.response?.data ?? 'DioError Null');
        if (e.response?.data != null) {
          try {
            data = Failure.fromJson(e.response?.data);
          } catch (e) {
            data = Failure(
              message: 'Error desconocido',
            );
          }
        }
      }
      return data;
    }
  }

  Future<Object> requestMap<T>(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    T Function(dynamic data)? parser,
  }) async {
    try {
      final response = await _dio
          .request<Map<String, dynamic>>(
            path,
            options: Options(
              method: method,
              headers: headers,
            ),
            queryParameters: queryParameters,
            data: data,
          )
          .timeout(durationLoading);
      if (_logsEnabled) _logger.i(response.data);
      if (parser != null) {
        return Success<T>(response: parser(response.data));
      }
      return Success(response: response.data!);
    } catch (e) {
      _logger.e(e);
      Failure data = Failure(
        message: 'No Internet',
      );
      if (e is DioError) {
        if (_logsEnabled) _logger.e(e.response?.data ?? 'DioError Null');
        if (e.response?.data != null) {
          try {
            data = Failure.fromJson(e.response?.data);
          } catch (e) {
            data = Failure(
              message: 'Error desconocido',
            );
          }
        }
      }
      return data;
    }
  }

  Future<Object> requestSpecial<T>(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    T Function(dynamic data)? parser,
  }) async {
    try {
      final response = await _dio
          .request<Map<String, dynamic>>(
            path,
            options: Options(
              method: method,
              headers: headers,
            ),
            queryParameters: queryParameters,
            data: data,
          )
          .timeout(durationLoading);
      if (_logsEnabled) _logger.i(response.data);
      if (parser != null) {
        return Success<T>(response: parser(response.data));
      }
      return Success(response: response.data!);
    } catch (e) {
      _logger.e(e);
      Failure data = Failure(
        message: 'No Internet',
      );
      if (e is DioError) {
        if (_logsEnabled) _logger.e(e.response?.data ?? 'DioError Null');
        if (e.response?.data != null) {
          try {
            data = Failure.fromJson(e.response?.data);
          } catch (e) {
            data = Failure(
              message: 'Error desconocido',
            );
          }
        }
      }
      return data;
    }
  }

  Future<Object> requestJson<T>(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    T Function(dynamic data)? parser,
  }) async {
    try {
      final response = await _dio
          .request<Map<String, dynamic>>(
            path,
            options: Options(
              method: method,
              headers: headers,
            ),
            queryParameters: queryParameters,
            data: data,
          )
          .timeout(durationLoading);
      if (_logsEnabled) _logger.i(response.data);
      if (_logsEnabled) _logger.i(response.realUri);
      if (parser != null) {
        return Success<T>(response: parser(response.data));
      }
      return Success(response: response.data!);
    } catch (e) {
      _logger.e(e);
      Failure data = Failure(
        message: 'No Internet',
      );
      if (e is DioError) {
        if (_logsEnabled) _logger.e(e.response?.data ?? 'DioError Null');
        if (e.response?.data != null) {
          try {
            data = Failure.fromJson(e.response?.data);
          } catch (e) {
            data = Failure(
              message: 'Error desconocido',
            );
          }
        }
      }
      return data;
    }
  }
}
