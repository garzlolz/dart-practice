import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_codebootcamp/Constance/routes.dart';
import 'package:flutter_application_codebootcamp/Utilites/ShowErrorDialog.dart';
import 'package:flutter_application_codebootcamp/services/auth/AuthException.dart';
import 'package:flutter_application_codebootcamp/services/auth/AuthService.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        appBar: AppBar(title: const Text('註冊')),
        body: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: 'enter your password'),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  await AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verfyRoute);
                } on InvalidEmailAuthException catch (e) {
                  await ShowErrorDialog(context, 'Invalid Email');
                } on WeakPassAuthException catch (e) {
                  await ShowErrorDialog(context, 'Weak Password!');
                } on EmailAlreadyUsedAuthException catch (e) {
                  await ShowErrorDialog(context, 'Email Already Been Used!');
                } on GenericAuthException {
                  await ShowErrorDialog(context, 'Register fail!');
                } catch (e) {
                  await ShowErrorDialog(context, e.toString());
                }
              },
              child: const Text('註冊'),
            ),
            TextButton(
              onPressed: () async {
                final routeSuccess =
                    Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('已經有帳號了嗎? 登入'),
            ),
          ],
        ));
  }
}
