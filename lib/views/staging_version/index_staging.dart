import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IndexStaging extends StatefulWidget {
  const IndexStaging({Key key}) : super(key: key);

  @override
  _IndexStagingState createState() => _IndexStagingState();
}

class _IndexStagingState extends State<IndexStaging> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.black,),
          ),
        title: Text('All Apps',style: TextStyle(color: Colors.black,fontSize: 21),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SvgPicture.asset("assets/images/cdl_logo.svg",
                    height: 50.0,
                    width: 50.0,),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SalesToolkit Test',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                      Text('SalesToolkit Test',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w200),),
                      Text('SalesToolkit Test',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w200),),


                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
