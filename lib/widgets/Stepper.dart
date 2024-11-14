import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


class ProgressStepper extends StatelessWidget {
  const ProgressStepper ({
    Key key,
    @required this.title,
    this.subtitle,
    this.stepper,

  }) : super(key: key);

  final String title;
  final String subtitle;
  final double stepper;




  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Container(
         height: MediaQuery.of(context).size.height * 0.16,
        decoration: BoxDecoration(

          color: Theme.of(context).primaryColor,
          // borderRadius: BorderRadius.circular(5),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50,),
                      Text(title,style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xff077DBB),fontSize: 20,fontFamily: 'Nunito SansRegular'),),
                      Text('Next : ${subtitle}')
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: LinearPercentIndicator(
                width: 160.0,
                lineHeight: 7.0,
                percent: stepper,
                progressColor: Color(0XFF56C596),
              ),
            )
          ],
        )
      ),
    );
  }
}
