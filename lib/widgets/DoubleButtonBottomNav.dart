import 'package:flutter/material.dart';


class DoubleBottomNavComponent extends StatelessWidget {
  const DoubleBottomNavComponent({
    Key key,
    @required this.text1,
    @required this.text2,
    @required this.callAction1,
    @required this.callAction2,
    this.compsender,
  }) : super(key: key);

  final String text1;
  final String text2;
  final Function callAction1;
   final Function callAction2;
    final Widget compsender;
  @override
  Widget build(BuildContext context) {
    return    Container(
      height: 70,
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(right: 20,left: 20),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.43,
            height: 50,
            decoration: BoxDecoration(
              // color: Color(0xff077DBB),
              borderRadius: BorderRadius.circular(1),
              border: Border.all(
                width: 1,
                color: Colors.blue
              )
            ),
            child: OutlinedButton(
              onPressed: callAction1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  text1,
                  style: TextStyle(color: Color(0xff077DBB),fontFamily: 'Nunito SansRegular'),

                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.43,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xff077DBB),
              borderRadius: BorderRadius.circular(1),
            ),
            child: TextButton(
              onPressed: callAction2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  text2,
                  style: TextStyle(color: Colors.white,fontFamily: 'Nunito SansRegular'),
                ),
              ) ,
            ),


          )

        ],
      ),
    );
  }
}

