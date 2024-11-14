import 'package:alert_dialog/alert_dialog.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
//import 'package:share_plus/share.dart';
// import 'package:share_plus/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';


class ReferralIndex extends StatefulWidget {
  const ReferralIndex({Key key}) : super(key: key);

  @override
  _ReferralIndexState createState() => _ReferralIndexState();
}

class _ReferralIndexState extends State<ReferralIndex> {

  @override
  void initState() {
    // TODO: implement initState

    getStaffID();
    super.initState();
  }

  int referalCount  = 0;
  int staffRefId = 0;
  List<dynamic> uncompleted = [];
  int countUncompleted = 0;
  List<dynamic> totalReferrals = [];
  getStaffID() async{
    final Future<Map<String,dynamic>> respose =   RetCodes().getReferalsAndStaffData();
    respose.then(
            (response) {

           print('this is referal ${response}');
          setState(() {
            referalCount = response['referralCount'];
            totalReferrals = response['totalReferral'];
            uncompleted = totalReferrals.where((element) => element['status']['value'] == 'InComplete').toList();
            countUncompleted = uncompleted.length;
            staffRefId = response['data']['id'];
          });

        }
    );

  }

  Future<void> share(String codeLink) async {
  //  await
    // FlutterShare.share(
    //     title: 'Referral Code',
    //     text: codeLink,
    //     // linkUrl: 'https://flutter.dev/',
    //     // chooserTitle: 'Example Chooser Title'
    // );
  }

  sendReferrals(String shareType ) async{
       final SharedPreferences prefs = await SharedPreferences.getInstance();
       String refId = prefs.getString('agentCode');
       String staffName = prefs.getString('username');
    switch (shareType) {
      case 'general' :
     //   MyRouter.popPage(context);
         String shareLink = AppUrl.referralLinkUrl + '15/${refId}';
         String useLink = 'Use this referral link from ${staffName} to register \n\n ${shareLink}';
            share(useLink);
      break;
      case 'ussd' :
       // MyRouter.popPage(context);
        String shareLink = '*5120*${staffRefId}#';
        String useLink = 'Use this referral link from ${staffName} to access our USSD service \n\n ${shareLink}';
      //  Share.share(useLink,);
        share(useLink);
        break;
      case 'mobile' :
      //  MyRouter.popPage(context);
        String shareLink = '*5120*2*${refId}#';
        String useLink = 'Use this referral link from ${staffName} to register on our mobile App \n\n ${shareLink}';
      // Share.share(useLink,);
        share(useLink);
        break;


    }

  }
  showAlertForSharing(){
    return alert(
      context,
      title: Container(
        width: MediaQuery.of(context).size.width,

        decoration: BoxDecoration(

          color: Colors.white,
         // borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Share',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
                child: Icon(Icons.cancel)
            )
          ],
        ),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.18,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            // InkWell(
            //     onTap: (){
            //       sendReferrals('general');
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text('Share referral link'),
            //         Icon(Icons.arrow_forward_ios)
            //       ],
            //     )
            // ),
            // SizedBox(height: 11,),
            InkWell(
                onTap: (){
                  sendReferrals('ussd');
                },
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Share USSD code'),
                    Icon(Icons.arrow_forward_ios)
                  ],
                )
                // Text('Share USSD code')
            ),
            SizedBox(height: 9,),
            InkWell(
                onTap: (){
                  sendReferrals('Mobile App');
                },
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mobile App'),
                    Icon(Icons.arrow_forward_ios)
                  ],
                )
                // Text('Mobile App')

            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            MyRouter.popPage(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
        ),
      ),
      body:
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Referrals',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 26),)
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Earn more commission by sharing your referral link.',style: TextStyle(color: Colors.grey,fontSize: 14),)
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  _singleCard('assets/images/customers.png',referalCount.toString(),'Total referred'),
                  _singleCard('assets/images/leads.png',countUncompleted.toString(),'Uncompleted',),
                  _singleCard('assets/images/mail.png','N/A','Commission',),

                ],
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width * 0.93,
                height: 50,
                decoration: BoxDecoration(
                  // color: Color(0xff077DBB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 1,
                        color: Colors.blue
                    )
                ),
                child:

                OutlinedButton(
                  onPressed: (){
                    showAlertForSharing();
                  },
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Start Sharing',
                          style: TextStyle(color: Color(0xff077DBB),fontFamily: 'Nunito SansRegular'),

                        ),
                      ),




                    ],
                  ),
                ),
              ),

             // SizedBox(height: 30,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text('Referrals',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),)
              //   ],
              // ),
              // SizedBox(height: 10,),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: TabStatus(),
              )

            ],
          ),
        ),
      ),
    );
  }


  _singleCard(String image,String numbers,String title){
    return Card(
      elevation: 0.3,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.27 ,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11,vertical: 11),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [


                  Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(

                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.contain,
                        )
                    ),
                  ),
                  Text(''),

                  // ImageIcon(
                  //   AssetImage(image),
                  //   size: 22,
                  // ),

                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(numbers,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                  Text('')
                ],

              ),

              Row(
                children: [
                  Text(title,style: TextStyle(fontSize: 11),),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget TabStatus(){
   return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            bottom:   TabBar(

              indicatorColor: Colors.red,
              tabs: [
                Tab(
                  child: Text('Completed',style: TextStyle(fontSize: 14,color: Color(0xff177EB9),fontFamily: 'Nunito SansRegular'),),
                ),
                Tab(
                  child: Text('Pending',style: TextStyle(fontSize: 14,color: Color(0xff177EB9),fontFamily: 'Nunito SansRegular'),),
                ),

              ],
              labelColor: Color(0xff177EB9),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: MaterialIndicator(
                height: 2,
                topLeftRadius: 0,
                topRightRadius: 0,
                bottomLeftRadius: 0,
                bottomRightRadius: 0,
                tabPosition: TabPosition.bottom,
                color: Colors.blue
              ),
            ),
          ),
          body: TabBarView(
            children: [
              FirstTab(),
              SecondTab()
            ],
          ),
        )


    );
  }


  Widget FirstTab(){
    var filteredComplete = totalReferrals.where((element) => element['status']['value'] != 'InComplete').toList();

    print('filtered records  ${filteredComplete}');


    return filteredComplete.length == 0 ? Text('No Complete Client'):

      ListView.builder(
      shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        primary: false,
        itemCount: filteredComplete.length,
        itemBuilder: (index,position){
          var clientData = filteredComplete[position];
            return ListTile(
              title: Text('${clientData['displayName']}',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w600),),
              trailing:
              clientStatus(Color(0xffd6f5d3),Colors.green ,'completed'),
              subtitle: Text('${clientData['mobileNo']}'),
            );
        });
  }


  Widget SecondTab(){
    var filteredComplete = totalReferrals.where((element) => element['status']['value'] == 'InComplete').toList();

    print('filtered records  ${filteredComplete}');

    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        primary: false,
        itemCount: filteredComplete.length,
        itemBuilder: (index,position){




          print('filtered records ${filteredComplete} ${filteredComplete}');



          var clientData = filteredComplete[position];
          return ListTile(
            title: Text('${clientData['displayName']}',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w600),),
            trailing:
            clientStatus(Color(0xfff28a1b),Colors.white ,'Pending'),
            subtitle: Text('${clientData['mobileNo']}'),
          );
        });
  }

  Widget clientStatus(Color statusColor,Color textColor,String status) {
    return Container(
      width: 75,
      height: 23,
      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: statusColor,
        boxShadow: [
          BoxShadow(color: statusColor, spreadRadius: 0.1),
        ],
      ),
      child: Center(
          child: Text(status,style: TextStyle(color: textColor),)
      ),
    );
  }
  
}
