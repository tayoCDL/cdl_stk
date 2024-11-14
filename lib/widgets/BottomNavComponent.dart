import 'package:flutter/material.dart';


class BottomNavComponent extends StatelessWidget {
  const BottomNavComponent({
    Key key,
    @required this.text,

    @required this.callAction,

  }) : super(key: key);

  final String text;
  final Function callAction;

  @override
  Widget build(BuildContext context) {
return    Container(
  height: 70,
  //color: Theme.of(context).primaryColor,
  padding: EdgeInsets.only(right: 20),
  width: MediaQuery.of(context).size.width,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(''),
      Container(
        width: MediaQuery.of(context).size.width * 0.38,
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xff077DBB),
          borderRadius: BorderRadius.circular(1),
        ),
        child: TextButton(
          onPressed: callAction,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      )

    ],
  ),
);
  }
}

