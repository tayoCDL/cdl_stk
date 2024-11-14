import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sales_toolkit/views/Interactions/ItHelpDesk.dart';
import 'package:sales_toolkit/views/Interactions/IthelpdeskLists.dart';
import 'package:sales_toolkit/views/attendance/Attendance_Index.dart';
import 'package:sales_toolkit/views/draft/DraftOverview.dart';
import 'package:sales_toolkit/views/product_description/productIndex.dart';
import 'package:sales_toolkit/views/referrals/referralIndex.dart';
import 'package:sales_toolkit/widgets/testLocation.dart';

import '../../util/router.dart';

class MenuIndex extends StatefulWidget {
  const MenuIndex({Key key}) : super(key: key);

  @override
  _MenuIndexState createState() => _MenuIndexState();
}

class _MenuIndexState extends State<MenuIndex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back_ios,
        //     color: Color(0xff205072),
        //   ),
        //   onPressed: () {
        //     MyRouter.popPage(context);
        //   },
        // ),
        centerTitle: true,
        title: Text(
          'Menu',
          style: TextStyle(
              color: Color(0xff205072), fontSize: 21, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(

          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 25,horizontal: 10),
          child: Column(
            children: [
              menuItemList('Draft', FeatherIcons.bookOpen,onTap: (){
                MyRouter.pushPage(context, DraftOverview());
              }),
             menuItemList('Referrals', Icons.share,onTap: (){
                 MyRouter.pushPage(context, ReferralIndex());
              }),
              menuItemList('IT Help Desk', FeatherIcons.phoneCall,
              onTap: (){
                MyRouter.pushPage(context, ItHelpDeskLists());
              }
              ),
            //  menuItemList('Support', Icons.info),
            //   menuItemList('Product Information', FeatherIcons.info,onTap: (){
            //     MyRouter.pushPage(context, ProductIndex());
            //   }),
            ],
          ),
        ),
      ),
    );
  }


  Widget menuItemList(String title,IconData iconData,{Function onTap}){
    return  Column(
      children: [
        InkWell(
          onTap: onTap,
          child: ListTile(
            leading: Icon(iconData, color: Color(0xff000000),size: 25,),
            title: Text(title,style: TextStyle(fontSize: 18,color: Color(0xff205072),fontWeight: FontWeight.w500),),
            trailing: Icon(Icons.arrow_forward_ios, color: Color(0xff000000)),
          ),
        ),
       SizedBox(height: 3,),
        Divider(color: Colors.grey,),
      ],
    );
  }
}
