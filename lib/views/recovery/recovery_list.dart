import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/view_models/CodesAndLogic.dart';
import 'package:sales_toolkit/views/recovery/single_recovery_view.dart';


class RecoveryList extends StatefulWidget {
  const RecoveryList({Key  key}) : super(key: key);

  @override
  _RecoveryListState createState() => _RecoveryListState();
}

class _RecoveryListState extends State<RecoveryList> {


  List<dynamic> collectionList = [];

  final formatCurrency = NumberFormat.currency(locale: "en_US",
      symbol: "");

  @override
  void initState() {

    getListsRecovery();
    super.initState();

  }

  getListsRecovery() async {

    final Future<Map<String,dynamic>> respose =   RetCodes().getRcoveryLists();

    respose.then((response) {
      print('response ${response['data']}');
     var newClientData = response['data']['pageItems'];
      setState(() {
        collectionList = newClientData;
      });
      print(collectionList);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text('Recovery', style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headline6.color,
              fontFamily: 'Nunito Bold')),
        ),
        centerTitle: false,
        // leading: IconButton(
        //   onPressed: (){
        //     MyRouter.popPage(context);
        //   },
        //   icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
        // ),
        actions: [
          // IconButton(onPressed: (){}, icon: Icon(Icons.search),color: Colors.blue,),
          // IconButton(onPressed: (){}, icon: Icon(FeatherIcons.sliders),color: Colors.blue,),

        ],
      ),
      body: RefreshIndicator(
        onRefresh: ()=> getListsRecovery(),
        child: collectionList.isEmpty ? NoRecoveryView() :
        Container(
              child: ListView.builder(
                  itemCount: collectionList.length == null || collectionList.isEmpty ? 0 : collectionList.length,
                  itemBuilder: (index,position){
                    print('this number ${collectionList[position]['ticketNumber']}');
                      return  _leadsContactView(Color(0xFF3FC0E0),'${collectionList[position]['loan']['clientName']}',
                          '','${collectionList[position]['loan']['clientName'].toString().substring(0,2)}',
                          '${collectionList[position]['loan']['loanProductName']}','',
                          collectionList[position]['loan']['summary']['totalOverdue'],
                          '${collectionList[position]['daysOverDue']} days overdue',Colors.red,(){
                        MyRouter.pushPage(context, SingleRecoveryView(loanId: collectionList[position]['loan']['id'],
                          ticketNumber: collectionList[position]['ticketNumber'],
                          collectionID: collectionList[position]['id'],));
                        });
              }),

            // child: Column(
            //   children: [
            //     _leadsContactView(Colors.red,'Tayo Oladosu','20-10-2020','OT','Federal loan','Active','10000','20 days overview',Colors.red,(){
            //       MyRouter.pushPage(context, SingleRecoveryView());
            //     })
            //   ],
            // ),


        ),
      ),
    );
  }

  _LeadingUserTile(Color cols,String nameLogo){
    return Container(
      padding: EdgeInsets.only(top: 1),
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: cols,
        borderRadius: BorderRadius.all(Radius.circular(60)),

      ),
      child: Center(child: Text(nameLogo,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)),
    );
  }

  _leadsContactView(Color colm,String title,String date,
      String nameLogo,String loanType,String loanStatus,
      var amount,String overDue,Color ColorStatus,Function onTap){
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
        child: Card(
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
            height: 80,
            child: ListTile(
                leading: _LeadingUserTile(colm,nameLogo.toUpperCase()),
                title: Text(title,style: TextStyle(color:Theme.of(context).textTheme.headline6.color,fontFamily: 'Nunito SansRegular',fontSize: 10,fontWeight: FontWeight.w600),),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(loanType),
                    SizedBox(width: 10,),
                    Text(loanStatus)
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                      Text('₦${formatCurrency.format(amount)}'),
                    SizedBox(height: 5,),
                    Text(overDue,style: TextStyle(fontSize: 12,color: ColorStatus,fontWeight: FontWeight.bold),),

                  ],
                )

                // Icon(Icons.arrow_forward_ios_rounded,size: 20,color: Colors.blueGrey,)
            ),
          ),
        ),
      ),
    );
  }


  Widget NoRecoveryView(){
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.27),
            SvgPicture.asset("assets/images/no_loan.svg",
              height: 90.0,
              width: 90.0,),
            SizedBox(height: 20,),
            Text('No Recovery Records, yet.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Text('No recovery found.',style: TextStyle(color: Colors.black,fontSize: 14,),),
            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }



}
