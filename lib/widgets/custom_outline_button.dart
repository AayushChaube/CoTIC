import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final double desktopMaxWidth;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;
  final String buttonTitle;
  final double buttonRadius;
  final double buttonBorderWidth;
  final double buttonHeight;
  final FontWeight textWeight;
  final double textSize;

  const CustomOutlineButton({
    @required this.desktopMaxWidth,
    @required this.onPressed,
    this.borderColor = Colors.red,
    @required this.textColor,
    @required this.buttonTitle,
    @required this.buttonRadius,
    @required this.buttonBorderWidth,
    @required this.buttonHeight,
    this.textWeight = FontWeight.w700,
    this.textSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: desktopMaxWidth,
          minHeight: buttonHeight,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(buttonRadius),
          border: Border.all(
            color: borderColor,
            width: buttonBorderWidth,
          ),
        ),
        child: Center(
          child: Text(
            buttonTitle,
            style: Theme.of(context).textTheme.headline6.copyWith(
              color: textColor,
              fontSize: textSize,
              fontWeight: textWeight,
            ),
          ),
        ),
      ),
    );
  }
}
