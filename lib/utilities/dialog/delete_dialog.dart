import 'package:flutter/cupertino.dart';
import 'package:flutter_application_codebootcamp/utilities/dialog/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Delete',
      content: 'Are you sure you gonna delte this item?',
      optionBuilder: () => {
            'Cancel': false,
            'Delete': true,
          }).then((value) => value ?? false);
}
