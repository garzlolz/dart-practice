import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_codebootcamp/services/auth/AuthException.dart';
import 'package:flutter_application_codebootcamp/services/auth/AuthProvider.dart';
import 'package:flutter_application_codebootcamp/services/auth/AuthUser.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Auth', () {
    final provider = MockAuthProvider();

    test('Should not be inited to begin with', () {
      expect(
        provider.isInitailize,
        false,
      );
    });

    test('Cannot Log out if not inited', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializeException>()),
      );
    });

    test('Should be inited', () async {
      await provider.initalize();
      expect(provider.isInitailize, true);
    });

    test('User should be null after inited', () {
      expect(provider.currnetUser, null);
    });

    test('Should be able to init in less 2s', () async {
      await provider.initalize();
      expect(provider.isInitailize, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Create User should be delegate to login funciton', () async {
      final badEmailUser = provider.createUser(
        email: 'oscar@gmail.com',
        password: '8weqw612',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPasswordUser =
          provider.createUser(email: 'oscaewr@gmail.com', password: '8612');
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));
      final user = await provider.createUser(
        email: 'alex',
        password: '6565',
      );
      expect(provider.currnetUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Mock User should be get verified', () {
      provider.sendEmailVerification();
      final _user = provider.currnetUser;
      expect(_user, isNotNull);
      expect(_user!.isEmailVerified, true);
    });

    test('Should be albe to logg out again and agin', () async {
      await provider.logOut();
      await provider.login(email: 'user', password: 'password');
      final user = provider.currnetUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializeException {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitailize = false;
  bool get isInitailize => _isInitailize;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitailize) throw NotInitializeException();
    await Future.delayed(const Duration(seconds: 1));
    return login(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currnetUser => _user;

  @override
  Future<void> initalize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitailize = true;
  }

  @override
  Future<void> logOut() async {
    if (!isInitailize) {
      throw NotInitializeException();
    }
    if (_user == null) {
      throw UserNotFoundAuthException();
    }
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    if (!isInitailize) {
      throw NotInitializeException();
    }
    if (email == 'oscar@gmail.com') {
      throw UserNotFoundAuthException();
    }
    if (password == '8612') {
      throw WrongPasswordAuthException();
    }
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitailize) {
      throw NotInitializeException();
    }
    final user = _user;
    if (user == null) {
      throw UserNotFoundAuthException();
    }
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
