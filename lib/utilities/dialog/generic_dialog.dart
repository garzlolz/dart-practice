import 'package:flutter/material.dart';

typedef DialoagOptionBuilder<E> = Map<String, E?> Function();

Future<E?> showGenericDialog<E>({
  required BuildContext context,
  required String title,
  required String content,
  required DialoagOptionBuilder optionBuilder,
}) async {
  final options = optionBuilder();
  return showDialog<E>(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: options.keys.map((optionTitle) {
            final value = options[optionTitle];
            return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionTitle),
            );
          }).toList(),
        );
      }));
}
