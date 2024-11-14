import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sales_toolkit/palatte.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/views/orders/createNewOrder.dart';
import 'package:sales_toolkit/views/orders/createOrder.dart';
import 'package:sales_toolkit/views/orders/singleOrderView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

bool isScrolled = true;

class _OrderHistoryState extends State<OrderHistory> {

  clickOrder() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

   bool isLoggedIn =  prefs.getBool('loginState');
      print('isLogged ${isLoggedIn}');
   if(isLoggedIn == null || isLoggedIn == false){
     Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
       backgroundColor: Colors.red,
       title: "Error",
       message: 'Please take attendance before creating order',
       duration: Duration(seconds: 5),
     ).show(context);
   }
   else {
     MyRouter.pushPage(context, CreateNewOrder());
   }

  }

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: null, icon: Icon(Icons.search,color: Color(0xff147AD6)
            ,)),
          IconButton(onPressed: null, icon: Icon(FeatherIcons.filter,color: Color(0xff147AD6)
            ,)),

        ],
      ),
      body:
      NotificationListener<UserScrollNotification>(
        onNotification: (notification){
          if(notification.direction == ScrollDirection.forward){
            setState(() {
              isScrolled = true;
            });
          }
          else if (notification.direction ==ScrollDirection.reverse){
            setState(() {
              isScrolled = false;
            });
          }
        },
        child:
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: mediaSize.width * 0.05,),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Order History',textAlign: TextAlign.start,style: kHeading_black,),
                    Text('')
                  ],
                ),
                SizedBox(height: 20,),
                orderSingle()
              ],
            ),
          ),
        ),


      ),


        floatingActionButton:    FloatingActionButton.extended(
          onPressed: (){
            clickOrder();
            //MyRouter.pushPage(context, CreateNewOrder());
          },
          backgroundColor: Color(0xff147AD6),
          autofocus: true,
          isExtended: isScrolled,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(60))),
          label: Text('New Order'),
          icon: Icon(Icons.add),

        )
    );
  }

  Widget orderSingle(){
    var mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(25))
      ),
      child: Column(
        children: [
          Container(
            width: mediaSize.width,
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xffEDF2F6),
              borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft:  Radius.circular(10)
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order ID: 1234567',),
                Text('')
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft:  Radius.circular(10))

              ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Customer Number:'),
                    Text('Order Status:')
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('08037631751',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    Text('Approved',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
                  ],
                ),
                SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date: 05 Aug. 22 08:58 AM',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w200),),
                    InkWell(
                      onTap: (){
                        MyRouter.pushPage(context, SingleOrderView());
                      },
                        child: Row(
                          children: [
                            Text('View',style: TextStyle(color: Color(0xff077DBB),fontWeight: FontWeight.bold),),
                            SizedBox(width: 10,),
                            Icon(Icons.arrow_forward_ios,color: Color(0xff077DBB),size: 12,)
                          ],
                        )
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
