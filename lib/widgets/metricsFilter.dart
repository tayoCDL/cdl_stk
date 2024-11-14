import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_toolkit/widgets/rounded-button.dart';

import '../util/enum/color_utils.dart';


class MetricsFilterModal extends StatelessWidget {


  const MetricsFilterModal(
      {Key key, this.onChanged,
        this.controller1,
        this.controller2,
        this.onPress
      })
      : super(key: key);

  final void Function(String) onChanged;
  final  Function() onPress;
  final  TextEditingController controller1;
  final  TextEditingController controller2;



  @override
  Widget build(BuildContext context) {
    return

      Container(
      height:MediaQuery.of(context).size.height - 370,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                spreadRadius: MediaQuery.of(context).size.height,
                blurRadius: 1)
          ],
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      child:
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         //   SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(height: 40,),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Filter With Date',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Nunito SemiBold',fontSize: 21),
            
              ),
            ),
            SizedBox(height: 25,),
            StartAndEndDate(context, controller1, 'Start Period'),
            StartAndEndDate(context, controller2, 'End Period'),
            SizedBox(height: 20,),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: RoundedButton(
                    buttonText: 'Filter',
                    // onbuttonPressed: (){
                    //  // print('controller2 ${controller2.text}');
                    //  // print('controller1 ${controller1.text}');
                    //  // filterMetricsForSalesAgent();
                    // }
                  onbuttonPressed: onPress,

                ))
          ],
        ),
      ),
    );
  }



  Widget StartAndEndDate(BuildContext context,var controller,String dateText){
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.095,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,

              // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0)), // set rounded corner radius
            ),
            child:
            TextFormField(

              style: TextStyle(fontFamily: 'Nunito SansRegular',color: Colors.black),

              autofocus: false,
              readOnly: true,
              controller: controller,

              //comingFrom == 'CustomerPreview'
              // true and comingfrom customer preview is true
              decoration: InputDecoration(
                  suffixIcon:
                  IconButton(
                    onPressed: (){
                      // showDatePicker();
                        newDatePicker(context, controller);
                    },
                    icon:   Icon(Icons.date_range,color: Colors.grey
                      ,) ,
                  ) ,

                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.6),

                  ),
                  border: OutlineInputBorder(

                  ),
                  labelText: dateText,
                  //   floatingLabelStyle: TextStyle(color:Color(0xff205072)),
                  hintText: dateText,
                  hintStyle: TextStyle(color: Colors.black,fontFamily: 'Nunito SansRegular'),
                  labelStyle: TextStyle(fontFamily: 'Nunito SansRegular',color: Theme.of(context).textTheme.headline2.color)

              ),
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
      ),
    );
  }


  newDatePicker(BuildContext context,var controller){
   return DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1955, 3, 5),
        maxTime:  DateTime.now().add(Duration(days: 0,hours: 2)),
        onChanged: (date) {
          print('change $date');
          String retDate = retsNx360dates(date);
          controller.text = retDate;
        }, onConfirm: (date) {
          print('confirm $date');
        }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  //
  // showDatePicker(BuildContext context) {
  //   DateTime CupertinoSelectedDate = DateTime.now();
  //
  //   showCupertinoModalPopup(
  //       context: context,
  //       builder: (BuildContext builder) {
  //         return Container(
  //           height: MediaQuery.of(context).copyWith().size.height*0.40,
  //           color: Colors.white,
  //           child: Column(
  //             children: [
  //               Container(
  //                 height: 200,
  //                 child: CupertinoDatePicker(
  //                   mode: CupertinoDatePickerMode.date,
  //                   onDateTimeChanged: (value) {
  //                     if (value != null && value != CupertinoSelectedDate)
  //
  //                         CupertinoSelectedDate = value;
  //                         print(CupertinoSelectedDate);
  //                         String retDate = retsNx360dates(CupertinoSelectedDate);
  //                         print('ret Date ${retDate}');
  //                         //  repaymentDate.text = retDate;
  //
  //
  //                   },
  //                   initialDateTime: DateTime.now().add(Duration( days: 15, hours: 0)),
  //                   // minimumYear: 2022,
  //                   // maximumYear: 2022,
  //                   maximumDate: DateTime.now().add(Duration(days: 45, hours: 0)),
  //                   minimumDate: DateTime.now().add(Duration( days: 14, hours: 0)),
  //                 ),
  //               ),
  //               CupertinoButton(
  //                 child: const Text('OK'),
  //                 //  onPressed: () => Navigator.of(context).pop(),
  //                 onPressed: (){
  //                   String retDate = retsNx360dates(CupertinoSelectedDate);
  //                   print('ret Date ${retDate}');
  //                   // repaymentDate.text = retDate;
  //                   Navigator.of(context).pop();
  //                 },
  //               )
  //             ],
  //           ),
  //         );
  //       }
  //   );
  // }

  retsNx360dates(DateTime selected){
    DateTime selectedDate = DateTime.now();

    String newdate = selectedDate.toString().substring(0,10);
    print('newdate ${newdate} selected ${selected} added ${DateTime.now().add(Duration(days: 0))}');

    String formattedDate = DateFormat.yMMMMd().format(selected);

    String removeComma = formattedDate.replaceAll(",", "");


    List<String> wordList = removeComma.split(" ");
    //14 December 2011

    //[January, 18, 1991]
    String o1 = wordList[0];
    String o2 = wordList[1];
    String o3 = wordList[2];

    String concatss = o2 + " " + o1 + " " + o3;
    print("concatss");
    print(concatss);

    print(wordList);
    return concatss;
  }



}
