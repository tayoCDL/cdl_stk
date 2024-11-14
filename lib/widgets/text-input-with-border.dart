import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../palatte.dart';

class TextInputWithBorder extends StatelessWidget {
  const TextInputWithBorder({
    Key key,
    this.icon,
    @required this.isIconAvailable,
    @required this.hint,
    this.controls,
    this.maxLenght,
    this.onButtonPressed,
    this.isObscure,
    this.eyeOpen,
    this.inputType,
    this.inputAction,
    this.onSave,
    this.validate,
    this.suffixWidget
  }) : super(key: key);

  final IconData icon;
  final bool isIconAvailable;
  final String hint;
  final bool eyeOpen;
  final bool isObscure;
  final Function onButtonPressed;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Widget suffixWidget;
  final Function onSave;
  final Function validate;
  final TextEditingController controls;
  final int maxLenght;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        // height: 51,
        decoration: BoxDecoration(

          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),

        child: TextFormField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLenght),
          ],
          maxLength: maxLenght,
       //   maxLengthEnforced: false,
        //  maxLengthEnforcement: false,
          controller: controls,
          onSaved: onSave,
          // obscureText: Obs,
          validator: validate,
          decoration: InputDecoration(
            hintText: hint,
              counterText: '',
              hintStyle: kBodyPlaceholder,
              suffixIcon: isIconAvailable  == true ? suffixWidget : null,

              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),


              labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Color(0xff205072))

          ),
          style: kBodyText,

          keyboardType: inputType,
          textInputAction: inputAction,
        ),
      ),
    );
  }
}
