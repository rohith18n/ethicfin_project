import 'package:equatable/equatable.dart';

abstract class AppFailure extends Equatable {
  final String message;
  final int? statusCode;

  const AppFailure(this.message, [this.statusCode]);

  @override
  List<Object?> get props => [message, statusCode];

  @override
  String toString() => message;
}

class UserNotFoundFailure extends AppFailure {
  const UserNotFoundFailure([
    String message = 'User not found. Check the username and try again.',
  ]) : super(message, 404);
}

class RateLimitFailure extends AppFailure {
  final DateTime? resetTime;

  const RateLimitFailure([
    String message = 'API rate limit reached (60 req/hr for unauthenticated requests). Please wait a few moments.',
    this.resetTime,
  ]) : super(message, 403);

  @override
  List<Object?> get props => [message, statusCode, resetTime];
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([
    super.message = 'Unable to connect. Please check your internet connection.',
  ]);
}

class TimeoutFailure extends AppFailure {
  const TimeoutFailure([
    String message = 'Connection timed out. Please try again.',
  ]) : super(message, 408);
}

class ServerFailure extends AppFailure {
  const ServerFailure([
    super.message = 'GitHub service error. Please try again later.',
    super.statusCode,
  ]);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure([
    super.message = 'An unexpected error occurred. Please try again.',
  ]);
}
