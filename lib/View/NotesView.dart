import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_codebootcamp/Constance/routes.dart';

import 'package:flutter_application_codebootcamp/enums/menu_actions.dart';
import 'package:flutter_application_codebootcamp/firebase_options.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main App'),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              if (value == MenuAction.logout) {
                switch (value) {
                  case MenuAction.login:
                    // TODO: Handle this case.
                    break;
                  case MenuAction.logout:
                    final isLogout = await showOutDailog(context);
                    if (isLogout) {
                      await FirebaseAuth.instance.signOut();
                      Firebase.initializeApp(
                        options: DefaultFirebaseOptions.currentPlatform,
                      );
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    }
                    break;
                }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.login,
                  child: Text('Login'),
                ),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                )
              ];
            },
          )
        ],
      ),
      body: const Text('Hello Flutter !'),
    );
  }
}

Future<bool> showOutDailog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure for sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log Out'),
          )
        ],
      );
    },
  ).then((value) => value ?? false);
}
