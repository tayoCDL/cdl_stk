import 'package:flutter/material.dart';

import '../palatte.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    required this.icon,
    required this.isIconAvailable,
    required this.hint,
    required this.isObsure,
    required this.onSave,
    required  this.eyeOpen,
    required   this.controls,
    required  this.inputType,
    required   this.inputAction,
    required  this.onButtonPressed,
    this.validate,
  }) : super(key: key);

  final bool isIconAvailable;
  final bool isObsure;
  final bool eyeOpen;
  final IconData icon;
  final String?  hint;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Function(String?) onSave;
  final VoidCallback onButtonPressed;
  final FormFieldValidator<String>? validate;
  final TextEditingController controls;
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
          controller: controls,
          autofocus: false,
          onSaved: onSave!,
          validator: validate,
          obscureText: isObsure,
          decoration: InputDecoration(
            suffixIcon: isIconAvailable  == true ?
                IconButton(onPressed: onButtonPressed!, icon:  eyeOpen? Icon(Icons.visibility,color: Colors.black38
                  ,)  : Icon(Icons.visibility_off,color: Colors.black38
                  ,)
                ) : null ,
            contentPadding: const EdgeInsets.symmetric(vertical: 13,horizontal: 15),
            border: InputBorder.none,
            hintText: hint,
            hintStyle: kBodyPlaceholder,

          ),
          style: kBodyText,
          keyboardType: inputType,
          textInputAction: inputAction,
        ),
      ),
    );
  }
}
