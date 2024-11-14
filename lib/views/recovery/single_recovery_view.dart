import 'package:flutter/material.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/views/recovery/recovery_chat.dart';
import 'package:sales_toolkit/views/recovery/recovery_loan_detail.dart';
import 'package:sales_toolkit/views/recovery/recovery_overview.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class SingleRecoveryView extends StatefulWidget {
  final String ticketNumber;
  final int loanId,collectionID;
  const SingleRecoveryView({Key key,this.ticketNumber,this.loanId,this.collectionID}) : super(key: key);

  @override
  _SingleRecoveryViewState createState() => _SingleRecoveryViewState(
    ticketNumber:this.ticketNumber,
    loanId:this.loanId,
      collectionID:this.collectionID
  );
}

class _SingleRecoveryViewState extends State<SingleRecoveryView> {

   String ticketNumber;
   int loanId,collectionID;
  _SingleRecoveryViewState({this.ticketNumber,this.loanId,this.collectionID});
  @override
  Widget build(BuildContext context) {
  return
    DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: (){
              MyRouter.popPage(context);
            },
            icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
          ),
          bottom:   TabBar(

            indicatorColor: Colors.red,
            tabs: [
              Tab(
                child: Text('Overview',style: TextStyle(fontSize: 10,color: Color(0xff177EB9),fontFamily: 'Nunito SansRegular'),),
              ),
              Tab(
                child: Text('Loan Details',style: TextStyle(fontSize: 10,color: Color(0xff177EB9),fontFamily: 'Nunito SansRegular'),),
              ),
              Tab(
                child: Text('Ticket Engagements',style: TextStyle(fontSize: 10,color: Color(0xff177EB9),fontFamily: 'Nunito SansRegular'),),

              ),
            ],
            labelColor: Color(0xff177EB9),
            indicatorSize: TabBarIndicatorSize.label,
            indicator: MaterialIndicator(
              height: 5,
              topLeftRadius: 0,
              topRightRadius: 0,
              bottomLeftRadius: 5,
              bottomRightRadius: 5,
              tabPosition: TabPosition.bottom,
            ),
          ),
        ),
        body: TabBarView(
          children: [

            RecoveryOverview(collectionID: collectionID,),
            RecoveryLoanDetails(loanID: loanId,),
           RecoveryChat(ticketID: ticketNumber)

          ],
        ),
      )


    );
  }
}
