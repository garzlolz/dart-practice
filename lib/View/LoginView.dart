import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

import 'package:flutter_application_codebootcamp/Constance/routes.dart';

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
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                dev.log(userCredential.toString());
                if (userCredential.user?.emailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    note,
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (e.code.toLowerCase() == "user-not-found") {
                  dev.log('user not found!!');
                } else if (e.code.toLowerCase() == "wrong-password") {
                  dev.log('worng!!! pasword');
                } else {
                  dev.log(e.code);
                }
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
