import 'package:flutter/material.dart';
import 'package:sales_toolkit/palatte.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/router.dart';

class SingleOrderView extends StatefulWidget {
  const SingleOrderView({Key key}) : super(key: key);

  @override
  _SingleOrderViewState createState() => _SingleOrderViewState();
}

class _SingleOrderViewState extends State<SingleOrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.BACKGROUND_COLOR,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            MyRouter.popPage(context);
          },
          icon: Icon(Icons.arrow_back_ios,color:ColorUtils.PRIMARY_COLOR,),
        ),
        backgroundColor: Colors.white,
        title: Text('Order Details',style: kHeading4_black,),
    ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text('Order #1234567',style: kHeading4_black,textAlign: TextAlign.start,)),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date: 05 Aug. 22 08:58 AM',style: kHeading3_grey,),
                      Text('Approved',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
                    ],
                  )
                ],
              ),

            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('CUSTOMER DETAILS',style: kHeading4_grey,textAlign: TextAlign.start,)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 1),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 25),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))

                ),
                child: Column(
                  children: [
               userForm("Full Name", "Vincent Mayaki"),
                    SizedBox(height: 20,),
                    userForm("Address", "8 Michael Ogun Street, Ikeja, Lagos"),
                    SizedBox(height: 20,),
                    userForm("Phone Number", "08037631222"),
                    SizedBox(height: 15,),



                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('ITEM DETAILS',style: kHeading4_grey,textAlign: TextAlign.start,)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 1),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 25),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))

                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset('assets/images/device.png',width: 70,height: 120,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('S10+'),
                                Text('Device Amount'),
                                Text('N128,000'),

                              ],
                            ),
                              SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Device Amount'),
                                Text('N128,000'),
                              ],
                            )
                          ],
                        )
                      ],

                    ),
                    userForm("Item Name", "----"),
                    SizedBox(height: 20,),
                    userForm("Item Model", "----"),
                    SizedBox(height: 20,),
                    userForm("Item Description", "---"),
                    SizedBox(height: 15,),



                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userForm(String KeyName,String ValueName){
    return   Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(KeyName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),),
        Text(ValueName,style: TextStyle(fontSize: 17),)
      ],
    );
  }
}
