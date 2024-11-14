import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';

Widget clientStatus(Color statusColor,String status,{Color fontColor,double fontSize,double containerSIze,double brdradius,Function ontaPP,double containerHeight}) {
  return InkWell(
    onTap: ontaPP,
    child: Container(
      width: containerSIze ?? 105,
      height: containerHeight,
      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(brdradius ?? 20),
        color: statusColor,
        boxShadow: [
          BoxShadow(color: statusColor, spreadRadius: 0.1),
        ],
      ),
      child: Center(child: Text(status,style: TextStyle(color: fontColor ?? Colors.white,fontSize: fontSize ?? 15),)),
    ),
  );
}

IconChooser(String value){
  switch (value) {
    case 'NX360' :
     return Icon(Icons.desktop_windows,color: ColorUtils.PRIMARY_COLOR,size: 20,);
    break;
    case 'SALES TOOLKIT' :
    return  Icon(Icons.phone_android,color: ColorUtils.PRIMARY_COLOR,size: 20,);
    break;
    case 'USSD' :
      return  Icon(FeatherIcons.hash,color: ColorUtils.PRIMARY_COLOR,size: 20,);
      break;
    case 'Interswitch' :
      return  Icon(FeatherIcons.gitPullRequest,color: ColorUtils.PRIMARY_COLOR,size: 20,);
      break;
    default:
      return  Icon(FeatherIcons.zap,color: ColorUtils.PRIMARY_COLOR,size: 20,);

  }




}



 Map<String,dynamic> colorUtilsMap = {
  "DRAFT": 10,
  "SALES_SUBMITTED_AND_PENDING_APPROVAL": 50,
  "SUBMITTED_AND_PENDING_APPROVAL": 100,
  "APPROVED": 200,
  "AWAITING_TOKENIZATION": 205,
   "ACTIVE": 300,
   "REJECTED": 500,
 // "AWAITING_DISBURSAL": 210,
 // "DISBURSAL_IN_PROGRESS": 215,
 // "AWAITING_BANK": 217,
 // "FAILED": 250,

 // "TRANSFER_IN_PROGRESS": 303,
 // "TRANSFER_ON_HOLD": 304,
 // "WITHDRAWN_BY_CLIENT": 400,

//  "CLOSED_OBLIGATIONS_MET": 600,
//  "CLOSED_WRITTEN_OFF": 601,
//  "CLOSED_RESCHEDULE_OUTSTANDING_AMOUNT": 602,
//  "OVERPAID": 700,
};


int m_filterLoanView(String key) {
  int value = getValueForKey(key);
  print('Value for $key: $value');
  return value;
  // Implement your logic here based on the retrieved value
}

int getValueForKey(String key) {
  return colorUtilsMap[key] ?? -1; // Return -1 if key is not found
}


colorChoser(var vals){


  if(vals == "Closed"){
    return Colors.red;
  }
  if(vals == "Overdue"){
    return Colors.red;
  }

  if(vals == "Pending feedback"){
    return Colors.orangeAccent;
  }
  if(vals == "current_cycle"){
    return Color(0xfb7b3b3);
  }

  if(vals == "Resolved"){
    return Colors.blue;
  }
  if(vals == "Feedback provided"){
    return Colors.green;
  }
  if(vals == "Open"){
    return Colors.grey;
  }
  if(vals == "new"){
    return Colors.green;
  }
  if(vals == "reply"){
    return Colors.blue;
  }
  if(vals == "ACTIVE"){
    return Colors.green;
  }
  if(vals == "PENDING"){
    return Colors.orangeAccent;
  }
  if(vals == "INCOMPLETE"){
    return Colors.redAccent;
  }
  if(vals == "Customer"){
    return Colors.redAccent;
  }
  if(vals == "Staff"){
    return Colors.greenAccent;
  }

  if(vals == "Completed"){
    return Colors.green;
  }


  if(vals == "Sold"){
    return Color(0xff9c1010);
  }
  if(vals == "Customer Not Reached"){
    return Color(0xff990b6a);
  }
  if(vals == "Issues Dialing Code/completing flow"){
    return Color(0xff8dc467);
  }
  if(vals == "Network issues"){
    return Color(0xff1c43cb);
  }
  if(vals == "Customer to try later"){
    return Color(0xff13d6b7);
  }
  if(vals == "Not Interested"){
    return Color(0xff9f7b17);
  }


  if(vals == "METAL"){
    return ColorUtils.METAL;
  }
  if(vals == "BRONZE"){
    return ColorUtils.METAL;
  }
  if(vals == "SILVER"){
    return ColorUtils.SILVER;
  }
  if(vals == "GOLD"){
    return ColorUtils.GOLD;
  }
  if(vals == "PLATINIUM"){
    return ColorUtils.PLATINIUM;
  }
  if(vals == 10){
    return ColorUtils.DRAFT;
  }
  if(vals == 50){
    return ColorUtils.SALES_SUBMITTED_AND_PENDING_APPROVAL;
  }
  if(vals == 100){
    return ColorUtils.SUBMITTED_AND_PENDING_APPROVAL;
  }
  if(vals == 200){
    return ColorUtils.APPROVED;
  }
  if(vals == 205)
  {
    return ColorUtils.AWAITING_TOKENIZATION;
  }
  if(vals == 210){
    return ColorUtils.AWAITING_DISBURSAL;
  }
  if(vals == 215){
    return ColorUtils.DISBURSAL_IN_PROGRESS;
  }
  if(vals == 217){
    return ColorUtils.AWAITING_BANK;
  }

  if(vals == 250){
    return ColorUtils.FAILED;
  }

  if(vals == 300){
    return ColorUtils.ACTIVE;
  }

  if(vals == 303){
    return ColorUtils.TRANSFER_IN_PROGRESS;
  }
  if(vals == 304){
    return ColorUtils.TRANSFER_ON_HOLD;
  }
  if(vals == 400){
    return ColorUtils.WITHDRAWN_BY_CLIENT;
  }
  if(vals == 500){
    return ColorUtils.REJECTED;
  }
  if(vals == 600){
    return ColorUtils.CLOSED_OBLIGATIONS_MET;
  }
  if(vals == 601){
    return ColorUtils.CLOSED_WRITTEN_OFF;
  }
  if(vals == 602){
    return ColorUtils.CLOSED_RESCHEDULE_OUTSTANDING_AMOUNT;
  }
  if(vals == 700){
    return ColorUtils.OVERPAID;
  }









  else {
    return Colors.grey;
  }
}

get10(String val_10){
  String vals = val_10.substring(0,10);
  return vals;
}


String capit_alize(String cpText) {
  return "${cpText[0].toUpperCase()}${cpText.substring(1)}";
}

getHumanReadable(String hmReads){
 return hmReads.replaceAll('_', ' ').toUpperCase();
}





