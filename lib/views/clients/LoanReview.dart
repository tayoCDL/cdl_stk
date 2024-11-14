import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoanReview extends StatefulWidget {
  const LoanReview({Key key}) : super(key: key);

  @override
  _LoanReviewState createState() => _LoanReviewState();

  // final int clientID;
  // const SingleCustomerScreen({Key key,this.clientID}) : super(key: key);
  // @override
  // _SingleCustomerScreenState createState() => _SingleCustomerScreenState(
  //     clientID: this.clientID
  // );
}

class _LoanReviewState extends State<LoanReview> {



  // int clientID;
  // _SingleCustomerScreenState({this.clientID});

  var clientProfile = {};
  var employmentProfile = [];
  var residentialProfile = [];
  var bankInfo = [];
 // String converted ="data:image/png;base64,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";
  String converted = '';
  Uint8List myImage;

  @override
  void initState() {
    // TODO: implement initState
    getClientProfile();
    super.initState();
  }


  getClientProfile() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    print(tfaToken);
    print(token);
    Response responsevv = await get(
      AppUrl.getSingleClientForLoanReview + '554',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );
    print(responsevv.body);

    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    print(responseData2);
    var newClientData = responseData2;
    setState(() {
      clientProfile = newClientData;
      converted =   clientProfile['clientIdentifiers'][0]['attachment']['location'];


    });




     // Image.memory(_bytesImage);
    print(converted);
  }




  @override



  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,

      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: (){
                  MyRouter.popPage(context);
                },
                icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text( clientProfile.isEmpty ? '- -' : '${clientProfile['firstname'].toString()}' + " " '${clientProfile['lastname'].toString()}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: 'Nunito SansRegular',
                        fontWeight: FontWeight.bold
                    )),
                background: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: InkWell(
                      onTap: (){},
                      child:
                      Image.memory(
                          base64Decode(converted.substring(22).replaceAll("\n", "").replaceAll("\r", ""))
                      )
                  ),

                ),
              ),

            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: MediaQuery.of(context).size.height * 0.252,
                  child: ListView(
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Customer Type: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text('State',style: TextStyle(color: Colors.black,fontSize: 15,),)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Customer ID: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text('333',style: TextStyle(color: Colors.black,fontSize: 15,),)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Activation Date: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Text('27 November, 2010',style: TextStyle(color: Colors.black,fontSize: 15,),)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Client’s Status: ',style: TextStyle(fontSize: 13,color: Colors.grey[500],fontWeight: FontWeight.bold),),
                          Container(
                            width: 65,
                            padding: EdgeInsets.symmetric(horizontal: 4,vertical: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xff2FC8B6),
                              boxShadow: [
                                BoxShadow(color:  Color(0xff2FC8B6), spreadRadius: 0.1),
                              ],
                            ),
                            child: Center(child: Text('Active',style: TextStyle(color: Colors.white),)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),






              ],
            ),
          ),
        ),
      ),
    );
  }

  String checkisNull(var vals){
    if(vals.isEmpty){
      return 'N/A';
    }
    else {
      return vals;
    }


  }

}
