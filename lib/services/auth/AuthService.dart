import 'package:flutter_application_codebootcamp/services/auth/AuthProvider.dart';
import 'package:flutter_application_codebootcamp/services/auth/AuthUser.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService(this.provider);

  @override
  Future<AuthUser> Login({
    required String email,
    required String password,
  }) =>
      provider.Login(email: email, password: password);

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  // TODO: implement currnetUser
  AuthUser? get currnetUser => provider.currnetUser;

  @override
  Future<void> logOut() {
    provider.logOut();
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
