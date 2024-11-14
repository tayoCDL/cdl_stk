import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/widgets/ShimmerListLoading.dart';
import 'package:sales_toolkit/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecoveryLoanDetails extends StatefulWidget {
  final int loanID;
  const RecoveryLoanDetails({Key key,this.loanID}) : super(key: key);

  @override
  _RecoveryLoanDetailsState createState() => _RecoveryLoanDetailsState(
      loanID:this.loanID
  );
}

class _RecoveryLoanDetailsState extends State<RecoveryLoanDetails> {

  @override
  void initState() {
    // TODO: implement initState
    print('this is loanID ${loanID}');
    getLoanDetails();
    super.initState();
  }

  Map<String,dynamic> loanDetail = {};

  getLoanDetails() async{
    print('loanID ${loanID}');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    Response responsevv = await get(
      AppUrl.getLoanDetails + '${loanID.toString()}' + '?associations=all&exclude=guarantors,futureSchedule',
      headers: {
        'Content-Type': 'application/json',
        'Fineract-Platform-TenantId': FINERACT_PLATFORM_TENANT_ID,
        'Authorization': 'Basic ${token}',
        'Fineract-Platform-TFA-Token': '${tfaToken}',
      },
    );


    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    print(responseData2);
    var newClientData = responseData2;
    setState(() {
      loanDetail = newClientData;
    });
    print('Loan detail ${loanDetail}');

  }



  int loanID;

  _RecoveryLoanDetailsState({this.loanID});

  @override
  Widget build(BuildContext context) {


    void actionPopUpItemSelected(String value) {

      if (value == 'customer_info') {
        print('got here');
        // MyRouter.pushPage(context, SingleCustomerScreen(clientID: clientID,));
      } else if (value == 'interaction') {
        //      MyRouter.pushPage(context, ClientInteraction(clientID: clientID,));

      }
      else if (value == 'loans') {
        //    MyRouter.pushPage(context, LoanView(clientID: clientID,));

      }
      else if (value == 'new_interaction') {
        //   MyRouter.pushPage(context, AddInteraction());
      }
      else if (value == 'all_interaction') {
        //    MyRouter.pushPage(context, ClientInteraction(clientID: clientID,));
      }

      else {

      }

    }

    return Scaffold(

      body: SingleChildScrollView(
        child: loanDetail.isEmpty || loanDetail == null ? Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ShimmerListLoading()):

        Container(
          child: Column(
            children: [
              SizedBox(height: 10,),
              LoanHeader(),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Repayment Schedule',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),

                  ],
                ),
              ),
              SizedBox(height: 10,),

              Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                      physics: ScrollPhysics(),
                      itemCount: loanDetail['repaymentSchedule'] == null || loanDetail.isEmpty ? 0 : loanDetail['repaymentSchedule']['periods'].length,
                      itemBuilder: (context,int index){
                        return  ReapymentSchedule('${loanDetail['repaymentSchedule']['periods'][index]['principalLoanBalanceOutstanding']}','open' ,'${loanDetail['repaymentSchedule']['periods'][index]['dueDate'][0]} - ${loanDetail['repaymentSchedule']['periods'][index]['dueDate'][1]} - ${loanDetail['repaymentSchedule']['periods'][index]['dueDate'][2]}');
                      })



              )


            ],
          ),
        ),
      ),

    );
  }

  Widget LoanHeader(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 2,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Product Name: ', style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'Nunito SansRegular',fontSize: 16)),
                  Text('${loanDetail['loanProductName']}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),

                ],
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Loan Status: ', style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'Nunito SansRegular',fontSize: 16)),
                  Text(loanDetail['status'] == null ? '---': '${loanDetail['status']['value']}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),

                ],
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Loan Type: ', style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'Nunito SansRegular',fontSize: 16)),
                  Text(loanDetail['loanType'] == null ? '---': '${loanDetail['loanType']['value']}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),

                ],
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date Submitted: ', style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'Nunito SansRegular',fontSize: 16)),
                  Text(loanDetail['timeline'] == null ? '---':  '${loanDetail['timeline']['submittedOnDate'][0]} / ${loanDetail['timeline']['submittedOnDate'][1]}  / ${loanDetail['timeline']['submittedOnDate'][2]}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),

                ],
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Account No: ', style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'Nunito SansRegular',fontSize: 16)),
                  Text(loanDetail == null ? '---': '${loanDetail['accountNo']}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),

                ],
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Expected Maturity: ', style: TextStyle(fontWeight: FontWeight.w300,fontFamily: 'Nunito SansRegular',fontSize: 16)),
                  Text(loanDetail['timeline'] == null ? '---':  '${loanDetail['timeline']['expectedMaturityDate'][0]} / ${loanDetail['timeline']['expectedMaturityDate'][1]}  / ${loanDetail['timeline']['expectedMaturityDate'][2]}',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Nunito SansRegular',fontSize: 16),),

                ],
              ),
              SizedBox(height: 15,),


            ],
          ),
        ),
      ),
    );
  }


  Widget ReapymentSchedule(String title,String status,String duedate,){
    return Container(
      height: MediaQuery.of(context).size.height * 0.169,

      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        elevation: 0,
        child: Container(
          padding: EdgeInsets.only(top: 14),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Amount Due',style: TextStyle(fontSize: 18,fontFamily: 'Nunito SansRegular'),),
                    Container(
                      width: 65,
                      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff9c9595).withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(color:  Color(0xff9c9595), spreadRadius: 0.1),
                        ],
                      ),
                      child: Center(child: Text(status,style: TextStyle(color: Colors.white),)),
                    ),

                  ],

                ),
              ),
              Container(
                child: ListTile(
                  title:Text(title,style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                  trailing: Text('Due Date: ${duedate}'),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }

}
