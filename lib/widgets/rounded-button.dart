import 'package:flutter/material.dart';

import '../palatte.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    @required this.buttonText,
    @required this.onbuttonPressed,
     this.bgColor, this.borderColor,
    this.textColor,
    this.isPrimaryColor
  }) : super(key: key);

  final String buttonText;
  final Function onbuttonPressed;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final bool isPrimaryColor ;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: bgColor ?? Color(0xff077DBB),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor ?? Color(0xff077DBB))
      ),
      child: TextButton(
        onPressed: onbuttonPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            buttonText,
            style: (isPrimaryColor == null || isPrimaryColor == false) ? kButtonText : kButtonTextBlue,
          ),
        ),
      ),
    );
  }
}
