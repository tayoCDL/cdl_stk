import 'package:flutter/material.dart';


class TextInputWithFLoating extends StatelessWidget {

  const TextInputWithFLoating({
    Key key,
    @required this.hint,
    @required this.label,
    this.inputType,
    this.inputAction,
    @required this.nameController,
  }) : super(key: key);


  final String hint;
  final String label;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    var MediaSize = MediaQuery.of(context).size;
    return   Container(
      height: MediaSize.height * 0.080,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,

            // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)), // set rounded corner radius
          ),
          child: TextFormField(
            style: TextStyle(fontFamily: 'Nunito SansRegular'),
            keyboardType: TextInputType.number,

            controller: nameController,

            decoration: InputDecoration(
                focusedBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 0.4),
                ),
                border: OutlineInputBorder(
                ),
                labelText: label,
                hintText: hint,
                labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color)

            ),
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    );
  }
}
