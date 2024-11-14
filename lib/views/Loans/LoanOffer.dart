import 'package:flutter/material.dart';
import 'package:sales_toolkit/util/router.dart';

class LoanOffer extends StatefulWidget {
  const LoanOffer({Key key}) : super(key: key);

  @override
  _LoanOfferState createState() => _LoanOfferState();
}

class _LoanOfferState extends State<LoanOffer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            MyRouter.popPage(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
        ),
        title: Text('Loans',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [

              ],
            ),
          ),
        ),
    );
  }
}
