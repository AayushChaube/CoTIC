import 'package:flutter/material.dart';

Future<void> showLoading(BuildContext context) async {
  return await showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: Container(
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 5,
            ),
            CircularProgressIndicator(),
            SizedBox(
              width: 25,
            ),
            Text(
              "Loading",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    ),
  );
}
