import 'package:flutter_application_codebootcamp/services/auth/AuthUser.dart';

abstract class AuthProvider {
  AuthUser? get currnetUser;
  Future<AuthUser> Login({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
