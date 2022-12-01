import 'package:flutter/material.dart';
import 'package:flutter_application_codebootcamp/Constance/routes.dart';
import 'package:flutter_application_codebootcamp/Utilites/show_error_dialog.dart';
import 'package:flutter_application_codebootcamp/services/auth/auth_exception.dart';
import 'package:flutter_application_codebootcamp/services/auth/auth_service.dart';

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
                  Navigator.of(this.context).pushNamedAndRemoveUntil(
                    noteRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.of(this.context).pushNamedAndRemoveUntil(
                    verfyRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  'Wrong Password!',
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  'User Not Found!',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  "Authentication Error",
                );
              } catch (e) {
                await showErrorDialog(context, e.toString());
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Back to Register'),
          ),
        ],
      ),
    );
  }
}
