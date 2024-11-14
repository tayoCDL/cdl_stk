import 'package:flutter/material.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/widgets/go_backWidget.dart';

class ProductIndex extends StatefulWidget {
  const ProductIndex({Key key}) : super(key: key);

  @override
  _ProductIndexState createState() => _ProductIndexState();
}

class _ProductIndexState extends State<ProductIndex> {

  List<dynamic> productInformationList = [];

  @override
  void initState() {
    // TODO: implement initState

    getProductInformation();

    super.initState();
  }

  getProductInformation(){
    print('check info');
    final Future<Map<String,dynamic>> respose =   RetCodes().getProductInformation();

    respose.then((response) async {


      if(response['status'] == false){
        print('error');
      } else {
        print(response['data']);
        // print('this is response ' + response.toString());
        // if(!filteredLoans.isEmpty){
        //   setState(() {
        //      CustomerLists = filteredLoans;
        //   });
        // }
        // else {
        setState(() {
          productInformationList = response['data'];
        });
        // }


      //  print('customer Product ${CustomerLists}');
      }


    }
    );

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: appBack(context),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Product Information',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SemiBold',color: Colors.black),),
        centerTitle: true,
      ),
      // appBar: appBack(context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10,),

              Container(
                 height: MediaQuery.of(context).size.height * 1.2
                ,
               // color: Colors.white,
                child: ListView.builder(
                  itemCount: productInformationList == null ? 0 : productInformationList.length ?? 0,
                    itemBuilder: (index,position){
                      return   Container(
                        // height: 400,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            color: Colors.white,
                            child: ExpansionTile(
                              backgroundColor: Colors.white,
                              title: Text(
                                  '${productInformationList[position]['name']}',
                                  style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold)
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 22),
                                  child: Column(
                                    children: [

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Applicable Sector: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                          Text('${productInformationList[position]['sector']}',style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w300),)

                                        ],
                                      ),
                                      Divider(color: Colors.grey,),
                                      SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Document Required for TopUp ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),

                                        ],
                                      ),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${replacecommawithbullet(productInformationList[position]['documentNTB'])}',style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          Text('')
                                        ],
                                      ),

                                      Divider(color: Colors.grey,),
                                      SizedBox(height: 20,),
                                      Row(

                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Document Required for TopUp ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),

                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${replacecommawithbullet(productInformationList[position]['documentNTB'])}',style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          Text('')
                                        ],
                                      ),
                                      Divider(color: Colors.grey,),
                                      SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Document Required for Settlement ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                                          Text('',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),)

                                        ],
                                      ),
                                      // Divider(color: Colors.grey,),
                                      SizedBox(height: 20,),


                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    ),
              )



            ],
          ),
        ),
      )
    );
  }
  
  String replacecommawithbullet(String vals){
    return  vals.replaceAll(',', '\n');
  }
  
}
