class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class UserNotFoundException extends AppException {
  const UserNotFoundException([
    String message = 'User not found on GitHub. Please check the username.',
  ]) : super(message, 404);
}

class RateLimitException extends AppException {
  final DateTime? resetTime;

  const RateLimitException([
    String message = 'GitHub API rate limit exceeded. Please wait a few minutes before trying again.',
    this.resetTime,
  ]) : super(message, 403);
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No internet connection. Please check your network and retry.',
  ]);
}

class TimeoutException extends AppException {
  const TimeoutException([
    String message = 'Request timed out. Please try again.',
  ]) : super(message, 408);
}

class ServerException extends AppException {
  const ServerException([
    super.message = 'GitHub servers are currently experiencing issues. Please try later.',
    super.statusCode,
  ]);
}

class CacheException extends AppException {
  const CacheException([
    super.message = 'Failed to read/write local search cache.',
  ]);
}
