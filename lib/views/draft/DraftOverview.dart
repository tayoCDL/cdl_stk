import 'package:flutter/material.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/views/draft/ClientDraft.dart';
import 'package:sales_toolkit/views/draft/LeadDraft.dart';
import 'package:sales_toolkit/views/draft/LoanDraft.dart';
import 'package:sales_toolkit/views/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DraftOverview extends StatefulWidget {
  const DraftOverview({Key key}) : super(key: key);

  @override
  _DraftOverviewState createState() => _DraftOverviewState();
}

class _DraftOverviewState extends State<DraftOverview> {

  @override
  void initState() {
    // TODO: implement initState
    getTotalCounts();
    super.initState();
  }

  String totalClient = '0';
  String totalLead = '0';
  getTotalCounts() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var clients = prefs.getStringList('LeadDraftLists');
    var leads = prefs.getStringList('ListDraftClient');


    print('get full lead , ${prefs.getStringList('LeadDraftLists')}');
    print('get full client , ${prefs.getStringList('ListDraftClient')}');


    if(leads != null){
      setState(() {
        totalLead = leads.length.toString();
      });
    }
    else if(clients != null){
      totalClient = clients.length.toString();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            // MyRouter.pushPage(context, MainScreen());
            MyRouter.popPage(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
        ),

      ),
      body: SingleChildScrollView(

          child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text('Drafts',style: TextStyle(color: Colors.black,fontSize: 26,fontWeight: FontWeight.bold),),
                        ),

                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                    _singleCard(Color(0xff5473e9), '0', 'Last added: 22 Feb, 2020','Loan Request',(){
                      MyRouter.pushPage(context, LoanDraft());
                    }),
                        _singleCard(Color(0xff354FA8), totalClient, 'Last added: 22 Feb, 2020','New Clients',(){
                          MyRouter.pushPage(context, ClientDraftLists());
                        }),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _singleCard(Color(0xff43BFF6), totalLead, 'Last added: 22 Feb, 2020','New Leads',(){
                          MyRouter.pushPage(context, LeadDraftLists());
                        }),
                        _singleCard(Color(0xff3FC1CF), '0', 'Last added: 22 Feb, 2020','New Interactions', (){

                        }),

                      ],
                    ),
                  ],
                ),
          ),
      ),
    );
  }

  _singleCard(Color cols,String numbers,String dateAdded,String title,Function onButtonPress){
    return InkWell(
      onTap: onButtonPress,
      child: Card(
        elevation: 0.3,
        child: Container(

          width: MediaQuery.of(context).size.width * 0.41 ,
          height: MediaQuery.of(context).size.height * 0.24,
          decoration: BoxDecoration(
              color: cols,
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11,vertical: 11),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,style: TextStyle(color: Colors.white),),


                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(numbers,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                    Text('')
                  ],

                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.042),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Row(
                    children: [
                      Text(dateAdded,style: TextStyle(fontSize: 9,color: Colors.white),),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }



}
