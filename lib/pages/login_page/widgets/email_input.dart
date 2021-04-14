import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  final TextEditingController userEmailController;

  const EmailInput({
    @required this.userEmailController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: userEmailController,
      autocorrect: false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        enabledBorder: OutlineInputBorder(),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        hintText: "E-mail (Required)",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
