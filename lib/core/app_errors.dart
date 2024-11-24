import 'package:equatable/equatable.dart';

class AppException implements Exception {
  final String message;

  AppException({required this.message});

  @override
  String toString() {
    return message;
  }
}

class AppErrors extends Equatable {
  final String message;
  final String? type;

  const AppErrors({
    required this.message,
    this.type,
  });

  @override
  String toString() {
    return "App Error: $message";
  }

  @override
  List<Object?> get props => [message];
}
