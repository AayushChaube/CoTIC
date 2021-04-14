import 'package:flutter/material.dart';

Future<void> showAlertDialog(BuildContext context,
    {String title, String content}) async {
  return await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text("Ok"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    ),
  );
}
