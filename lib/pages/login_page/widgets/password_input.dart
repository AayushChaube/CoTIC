import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController userPasswordController;

  const PasswordInput({@required this.userPasswordController});
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: userPasswordController,
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
        hintText: "Password (Required)",
        hintStyle: TextStyle(color: Colors.black54),
      ),
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
