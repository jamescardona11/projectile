import 'failure.dart';
import 'success.dart';

typedef Err<T, R> = R Function(T error);
typedef Completion<T, R> = R Function(T success);

/// {@template result}
///
/// A value that represents either a success or a failure, including an
/// associated value in each case.
///
/// Result<ResponseError, ResponseSuccess>
///
/// inspired by https://github.com/epam-cross-platform-lab/dart_result_type
///
/// {@endtemplate}
abstract class ProjectileResult {
  /// Returns true if [Result] is [Failure].
  bool get isFailure => this is FailureResult;

  /// Returns true if [Result] is [Success].
  bool get isSuccess => this is SuccessResult;

  /// Returns a new value of [Failure] result.
  ///
  FailureResult get failure {
    if (isFailure) {
      return (this as FailureResult);
    }

    throw Exception(
      'Make sure that result [isFailure] before accessing [failure]',
    );
  }

  /// Returns a new value of [Success] result.
  SuccessResult get success {
    if (isSuccess) {
      return (this as SuccessResult);
    }

    throw Exception(
      'Make sure that result [isSuccess] before accessing [success]',
    );
  }

  /// Returns a new value of [Result] from closure
  R fold<R>(
      Err<FailureResult, R> failure, Completion<SuccessResult, R> success) {
    if (isSuccess) {
      final right = this as SuccessResult;
      return success(right);
    } else {
      final left = this as FailureResult;
      return failure(left);
    }
  }
}
