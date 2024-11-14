import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/views/main_screen.dart';

goBack(BuildContext context,String value,{Function newFn}){
  if(value == 'go_back'){
   MyRouter.popPage(context);
  }else if(value == 'go_home'){
    MyRouter.pushPageReplacement(context, MainScreen());
  }
}

Widget appBack(BuildContext context,){
  return
    PopupMenuButton(
    icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.blue,),
    itemBuilder: (context) {
      return [
        PopupMenuItem(
          value: 'go_back',
          child: Row(
            children: [
            //  Icon(Icons.arrow_back_ios,color: ColorUtils.PRIMARY_COLOR,),
              SizedBox(width: 5,),
              Text('Previous Screen',),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'go_home',
          child: Row(
            children: [
            //  Icon(FeatherIcons.home,color: ColorUtils.PRIMARY_COLOR,),
             SizedBox(width: 5,),
              Text('Go To Dashboard'),
            ],
          ),
        ),


      ];
    },
    onSelected: (String value) => goBack(context,value,
    ),
  );

}