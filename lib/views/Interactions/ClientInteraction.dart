import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/views/Interactions/AddInteraction.dart';
import 'package:sales_toolkit/views/Interactions/ClientInteractionChat.dart';
import 'package:sales_toolkit/widgets/client_status.dart';
import 'package:sales_toolkit/widgets/go_backWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientInteraction extends StatefulWidget {
  // const ClientInteraction({Key key}) : super(key: key);
  //
  // @override
  // _ClientInteractionState createState() => _ClientInteractionState();



  final int clientID;
  final String clientName,ClientEmail;
  const ClientInteraction({Key key,this.clientID,this.ClientEmail,this.clientName}) : super(key: key);
  @override
  _ClientInteractionState createState() => _ClientInteractionState(
      clientID: this.clientID,
      ClientEmail:this.ClientEmail,
      clientName: this.clientName
  );
}

var interactionData = [];


class _ClientInteractionState extends State<ClientInteraction> {
  int clientID;
  Timer _timerForInter;
  final String clientName,ClientEmail;
  _ClientInteractionState({this.clientID,this.ClientEmail,this.clientName});

  @override
  void initState() {
    // TODO: implement initState
    //_timerForInter = Timer.periodic(Duration(seconds: 3), (result) {
      getInteracctionForClient();
    // });

    print('clientname ${clientName}');
    super.initState();
  }



  getInteracctionForClient() async{
    print('clientID ${clientID}');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var sequesttoken = prefs.getString('sequestToken');
    print('sequestToken ${sequesttoken}');

    try{
      Response responsevv = await get(
        AppUrl.getRecentTicketByCLientId + '${clientID}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${sequesttoken}',
        },
      );
      print(responsevv.statusCode);

      final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
     // print(responseData2);
      var newClientData = responseData2['data'];
      setState(() {
        interactionData = newClientData;
      });
      print(interactionData);
    }
    catch(e){
      print( 'this is ${e}');
    }

  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: appBack(context),
          title: Text('Interactions',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
         centerTitle: true,
          actions: [
            IconButton(
              onPressed: (){
                // MyRouter.popPage(context);
                showSearch(context: context, delegate: InteractionSearch());
              },
              icon: Icon(FeatherIcons.search,color: Colors.blue,),
            ),
          ],
      ),
      body: SingleChildScrollView(
        child: interactionData.length == 0 ?

        RefreshIndicator(
          onRefresh: () => getInteracctionForClient(),
          child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: NoInteractionView()

          ),
        )
            :
        RefreshIndicator(
          onRefresh: () => getInteracctionForClient(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.all(16),
                 child: ListView.builder(
              itemCount: interactionData.length,
              primary: false,
              scrollDirection: Axis.vertical,
              itemBuilder: (context,position){
                return recentInteractions(interactionData[position]['ticketId'],interactionData[position]['title'],interactionData[position]['status'],(){
                  MyRouter.pushPage(context, ClientInteractionChat(ticketID: interactionData[position]['ticketId'],));

                },interactionData[position]['dueDate']
                );

              },
            )
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            MyRouter.pushPage(context, AddInteraction(
              clientName: clientName,
              ClientEmail: ClientEmail,
              ClientID: clientID,
            ));
          },
          child:     SvgPicture.asset("assets/images/new_plus.svg",
            height: 70.0,
            width: 70.0,)
      ),
    );

  }


  Widget recentInteractions(String ticketId,String title,String status,Function onTicketTapped,String duedate){
    return InkWell(
      onTap: onTicketTapped,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.189,

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

                      Text(ticketId),
                      // Container(
                      //   width: MediaQuery.of(context).size.width * 0.3,
                      //   padding: EdgeInsets.symmetric(horizontal: 4,vertical: 3),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(20),
                      //     color: Color(0xff9c9595).withOpacity(0.9),
                      //     boxShadow: [
                      //       BoxShadow(color:  Color(0xff9c9595), spreadRadius: 0.1),
                      //     ],
                      //   ),
                      //   child: Center(child: Text(status,style: TextStyle(color: Colors.white),)),
                      // ),
                      clientStatus(colorChoser(status), status,fontSize: 11)

                    ],

                  ),
                ),
                Container(
                  child: ListTile(
                    title:Text(title,style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.blue,),
                    subtitle: Text('Due Date: ${get10(duedate)}',style: TextStyle(fontSize: 11,color: Colors.grey,fontWeight: FontWeight.w200),),
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget NoInteractionView(){
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.27),
            SvgPicture.asset("assets/images/no_loan.svg",
              height: 90.0,
              width: 90.0,),
            SizedBox(height: 20,),
            Text('No Interaction Records, yet.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Text('This user currently has no interaction.',style: TextStyle(color: Colors.black,fontSize: 14,),),
            SizedBox(height: 20,),
            Container(
              width: 155,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xff077DBB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: (){
                  // MyRouter.pushPage(context, AddInteraction(
                  //   ClientEmail: 'NAmsjs',
                  //   ClientID: 0,
                  //   clientName:'Akaka',
                  // ));
                  MyRouter.pushPage(context, AddInteraction(
                    clientName: clientName,
                    ClientEmail: ClientEmail,
                    ClientID: clientID,
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child:   Text(
                    'Add New Interaction',
                    style: TextStyle( fontSize: 12,
                      color: Colors.white,),
                  ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


Widget NoSearchResult(){
  return Container(
    child: Center(
      child: Column(
        children: [
          SizedBox(height: 200),
          SvgPicture.asset("assets/images/no_loan.svg",
            height: 90.0,
            width: 90.0,),
          SizedBox(height: 20,),
          Text('No Interaction Records .',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height: 6,),
          Text('Your search returned no result,try again',style: TextStyle(color: Colors.black,fontSize: 14,),),
          SizedBox(height: 20,),

        ],
      ),
    ),
  );
}


class InteractionSearch extends SearchDelegate<String>{


  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    // throw UnimplementedError();
    return [IconButton(onPressed: (){
      query ='';
    }, icon: Icon(Icons.clear))];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // throw UnimplementedError();
    return IconButton(onPressed: (){}, icon: IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,

      ),
      onPressed: (){
        close(context, null);
      },
    ));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
  //  throw UnimplementedError();
    return NoSearchResult();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // throw UnimplementedError();

    Widget recentInteractions(String ticketId,String title,String status,Function onTicketTapped,){
      return InkWell(
        onTap: onTicketTapped,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.189,

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

                        Text(ticketId),
                        // Container(
                        //   width: 65,
                        //   padding: EdgeInsets.symmetric(horizontal: 4,vertical: 3),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(20),
                        //     color: Color(0xff9c9595).withOpacity(0.9),
                        //     boxShadow: [
                        //       BoxShadow(color:  Color(0xff9c9595), spreadRadius: 0.1),
                        //     ],
                        //   ),
                        //   child: Center(child: Text(status,style: TextStyle(color: Colors.white),)),
                        // ),
                      clientStatus(colorChoser(status), status,fontSize: 11)
                      ],

                    ),
                  ),
                  Container(
                    child: ListTile(
                      title:Text(title,style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),),
                      trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.blue,),
                     // subtitle: Text('Last updated: 2022-01-20',style: TextStyle(fontSize: 11,color: Colors.grey,fontWeight: FontWeight.w200),),
                    ),
                  )


                ],
              ),
            ),
          ),
        ),
      );
    }



    final suggestionsList  = query.isEmpty ? interactionData.take(5).toList() :
    interactionData.where((element) =>
    toBeginningOfSentenceCase(element['ticketId']).toString().contains(toBeginningOfSentenceCase(query)) ||
        element['ticketId'].toString().contains(query)||
        element['ticketId'].toString().startsWith(query.toUpperCase()) ||
        element['ticketId'].startsWith(query.toUpperCase())).toList();



    return ListView.builder(
      itemCount: suggestionsList.length,
      primary: false,
      scrollDirection: Axis.vertical,
      itemBuilder: (context,position){
        return recentInteractions(suggestionsList[position]['ticketId'],suggestionsList[position]['title'],suggestionsList[position]['status'],(){
          MyRouter.pushPage(context, ClientInteractionChat(ticketID: suggestionsList[position]['ticketId'],));

        });
      },
    );
  }


  Widget StatusColor (String value){
    return Text('value',style: TextStyle(color: value == 'Pending' ? Colors.orangeAccent : Colors.red),);
  }


}
