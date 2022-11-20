import 'package:flutter_application_codebootcamp/services/auth/AuthProvider.dart';
import 'package:flutter_application_codebootcamp/services/auth/AuthUser.dart';
import 'package:test/test.dart';

void main() {}

class NotInitializeExceptionP {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user = null;
  var _isInitailize = false;
  bool get isInitailize => _isInitailize;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitailize) throw NotInitializeExceptionP();
    await Future.delayed(const Duration(seconds: 1));
    return login(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currnetUser => _user;

  @override
  Future<void> initalize() {}

  @override
  Future<void> logOut() {}

  @override
  Future<AuthUser> login({required String email, required String password}) {}

  @override
  Future<void> sendEmailVerification() {}
}
