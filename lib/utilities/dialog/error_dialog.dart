import 'package:flutter/cupertino.dart';
import 'package:flutter_application_codebootcamp/utilities/dialog/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) async {
  return showGenericDialog(
    context: context,
    title: 'An Error Occured',
    content: text,
    optionBuilder: () => {
      'Ok': null,
    },
  );
}
