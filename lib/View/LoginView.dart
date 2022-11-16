import 'package:flutter/material.dart';
import 'package:flutter_application_codebootcamp/Constance/routes.dart';
import 'package:flutter_application_codebootcamp/Utilites/ShowErrorDialog.dart';
import 'package:flutter_application_codebootcamp/services/auth/AuthException.dart';
import 'package:flutter_application_codebootcamp/services/auth/AuthService.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'enter your email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'enter your password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().login(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currnetUser;
                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    noteRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verfyRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException {
                await ShowErrorDialog(
                  context,
                  'Wrong Password!',
                );
              } on WrongPasswordAuthException {
                await ShowErrorDialog(
                  context,
                  'User Not Found!',
                );
              } on GenericAuthException {
                await ShowErrorDialog(
                  context,
                  "Authentication Error",
                );
              } catch (e) {
                await ShowErrorDialog(context, e.toString());
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () async {
              final routeSuccess = Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Back to Register'),
          ),
        ],
      ),
    );
  }
}
