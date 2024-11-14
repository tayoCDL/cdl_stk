import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EntryField extends StatelessWidget {
  const EntryField({Key key,
    // required this.maxLenghtAllow,
    // required this.keyBoard,
    @required this.editController,
    @required this.labelText,
    @required this.hintText,
     this.suffixWidget,
      this.keyBoard,
      this.minLines,
  }) : super(key: key);


  // final int maxLenghtAllow;
  // final TextInputType keyBoard;
  final TextEditingController editController;
  final String labelText;
  final String hintText;
  final Widget suffixWidget;
  final TextInputType keyBoard;
    final int minLines;
  @override
  Widget build(BuildContext context) {
    var MediaSize = MediaQuery.of(context).size;
    return
      Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,

              // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0)), // set rounded corner radius
            ),
            child:
            TextFormField(
              // maxLength: maxLenghtAllow,
              style: TextStyle(fontFamily: 'Nunito SansRegular'),
              controller: editController,
              keyboardType: keyBoard,
              validator: (value) {
              },
              decoration: InputDecoration(
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.1),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.redAccent, width: 0.2),
                  ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(1.0)),
                  borderSide: const BorderSide(color: Colors.grey, width: 0.3),
                ), // your color

                  labelText: labelText,
                  floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                  hintText: hintText,
                  suffixIcon: suffixWidget,
                  hintStyle: TextStyle(color: Colors.black,fontFamily: 'Nunito SansRegular'),
                  //  labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color),
                  counter: SizedBox.shrink()
              ),
              minLines: minLines, // any number you need (It works as the rows for the textarea)
              // keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
      );



  }
}
