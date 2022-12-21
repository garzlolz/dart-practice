import 'package:flutter/material.dart';
import 'package:flutter_application_codebootcamp/Constance/routes.dart';
import 'package:flutter_application_codebootcamp/View/login_view.dart';
import 'package:flutter_application_codebootcamp/View/notes/notes_view.dart';
import 'package:flutter_application_codebootcamp/View/notes/new_note_view.dart';
import 'package:flutter_application_codebootcamp/View/register_view.dart';
import 'package:flutter_application_codebootcamp/View/verifyemail_view.dart';
import 'package:flutter_application_codebootcamp/services/auth/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'FireBase Fluttter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      noteRoute: (context) => const NotesView(),
      verfyRoute: (context) => const VerifyEmailView(),
      newNoteRoute: ((context) => const NewNoteView())
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initalize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currnetUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
