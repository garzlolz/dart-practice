import 'package:flutter/cupertino.dart';
import 'package:flutter_application_codebootcamp/utilities/dialog/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Log Out',
      content: 'Are you sure you gonna log out?',
      optionBuilder: () => {
            'Cancel': false,
            'Log Out': true,
          }).then((value) => value ?? false);
}
