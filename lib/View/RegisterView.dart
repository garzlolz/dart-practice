import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev show log;

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
        appBar: AppBar(title: const Text('Register')),
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
              decoration:
                  const InputDecoration(hintText: 'enter your password'),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final UserCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  if (e.code.toLowerCase() == 'weak-password') {
                    dev.log('weak password!');
                  } else if (e.code == "email-already-in-use") {
                    dev.log('email hase benn used');
                  } else if (e.code == "invalid-email") {
                    dev.log("invalid-email enterd");
                  } else {
                    dev.log(e.code);
                  }
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () async {
                final routeSuccess =
                    Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Login/',
                  (route) => false,
                );
              },
              child: const Text('Have an account? Login'),
            ),
          ],
        ));
  }
}
