import 'package:flutter_application_codebootcamp/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initalize();
  AuthUser? get currnetUser;
  Future<AuthUser> login({
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
