import 'package:flutter/material.dart';
import 'package:flutter_application_codebootcamp/Constance/routes.dart';
import 'package:flutter_application_codebootcamp/enums/menu_actions.dart';
import 'package:flutter_application_codebootcamp/services/CRUD/notes_service.dart';
import 'package:flutter_application_codebootcamp/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _noteService;
  String get userEmail => AuthService.firebase().currnetUser!.email!;

  @override
  void initState() {
    _noteService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _noteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
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
                        Navigator.of(this.context).pushNamedAndRemoveUntil(
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
                    child: Text('Add Note'),
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
        body: FutureBuilder(
          future: _noteService.getorCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return const Text("Your notes will apear here");
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
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
