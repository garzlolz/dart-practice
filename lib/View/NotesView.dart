import 'package:flutter/material.dart';
import 'package:flutter_application_codebootcamp/Constance/routes.dart';
import 'package:flutter_application_codebootcamp/enums/menu_actions.dart';
import 'package:flutter_application_codebootcamp/services/auth/AuthService.dart';

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
                    break;
                  case MenuAction.logout:
                    final isLogout = await showOutDailog(context);
                    if (isLogout) {
                      await AuthService.firebase().logOut();
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
