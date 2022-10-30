import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_codebootcamp/firebase_options.dart';

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
      appBar: AppBar(title: const Text('Login')),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
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
                      decoration: const InputDecoration(
                          hintText: 'enter your password'),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () async {},
                          child: const Text('Back to Register'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            try {
                              final userCredential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);
                              print(userCredential);
                            } on FirebaseAuthException catch (e) {
                              if (e.code.toLowerCase() == "user-not-found") {
                                print('user not found!!');
                              } else if (e.code.toLowerCase() ==
                                  "wrong-password") {
                                print('worng!!! pasword');
                              } else {
                                print(e.code);
                              }
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ],
                );
              default:
                return const Text("loading");
            }
          }),
    );
  }
}
