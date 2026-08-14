import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final Dio dio;
  final SharedPreferences? sharedPreferences;

  ApiClient({Dio? customDio, this.sharedPreferences})
      : dio = customDio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                connectTimeout: ApiConstants.connectTimeout,
                receiveTimeout: ApiConstants.receiveTimeout,
                headers: ApiConstants.defaultHeaders,
                responseType: ResponseType.json,
              ),
            ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final savedToken = sharedPreferences?.getString('github_token') ?? '';
          final token = savedToken.isNotEmpty ? savedToken : ApiConstants.githubToken;
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(e.toString());
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        final serverMessage = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : null;

        if (statusCode == 404) {
          return UserNotFoundException(
            serverMessage ?? 'User not found on GitHub.',
          );
        } else if (statusCode == 403) {
          // Check for rate limit headers
          final resetHeader = error.response?.headers.value('x-ratelimit-reset');
          DateTime? resetTime;
          String rateLimitMsg = 'GitHub API rate limit exceeded (60 req/hr). Add a GitHub Token in settings for 5,000 req/hr.';
          if (resetHeader != null) {
            final epoch = int.tryParse(resetHeader);
            if (epoch != null) {
              resetTime = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
              final remainingMins = resetTime.difference(DateTime.now()).inMinutes;
              if (remainingMins > 0) {
                rateLimitMsg = 'GitHub rate limit reached. Resets in $remainingMins min (or add a GitHub Token for 5,000 req/hr).';
              }
            }
          }
          return RateLimitException(rateLimitMsg, resetTime);
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(
            serverMessage ?? 'GitHub server error ($statusCode).',
            statusCode,
          );
        }
        return AppException(serverMessage ?? 'HTTP Error ($statusCode)', statusCode);

      case DioExceptionType.cancel:
        return const AppException('Request was cancelled');

      case DioExceptionType.unknown:
      default:
        if (error.error != null &&
            error.error.toString().toLowerCase().contains('socketexception')) {
          return const NetworkException();
        }
        return AppException(error.message ?? 'An unexpected network error occurred');
    }
  }
}
