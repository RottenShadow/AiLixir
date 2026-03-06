import 'package:ailixir/core/errors/api/api_failure.dart';

class AuthEmailUnverified extends ApiFailure {
  final String email;
  AuthEmailUnverified({required this.email, required super.message});
}
