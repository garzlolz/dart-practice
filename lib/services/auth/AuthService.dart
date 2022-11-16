import 'package:flutter_application_codebootcamp/services/auth/AuthProvider.dart';
import 'package:flutter_application_codebootcamp/services/auth/AuthUser.dart';
import 'package:flutter_application_codebootcamp/services/auth/FirebaseAuthProvider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(email: email, password: password);

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
  Future<void> logOut() async {
    provider.logOut();
  }

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initalize() async => provider.initalize();
}
