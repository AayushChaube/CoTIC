import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double desktopMaxWidth;
  final VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;
  final String buttonTitle;
  final double buttonRadius;
  final double buttonHeight;
  final FontWeight textWeight;
  final double textSize;

  const CustomButton({
    @required this.desktopMaxWidth,
    @required this.onPressed,
    this.buttonColor = Colors.red,
    @required this.textColor,
    @required this.buttonTitle,
    @required this.buttonRadius,
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
          color: buttonColor,
          borderRadius: BorderRadius.circular(buttonRadius),
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
