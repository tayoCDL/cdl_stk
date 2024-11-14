import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/views/draft/ViewLeadDraft.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadDraftLists extends StatefulWidget {
  const LeadDraftLists({Key key}) : super(key: key);

  @override
  _LeadDraftListsState createState() => _LeadDraftListsState();
}

class _LeadDraftListsState extends State<LeadDraftLists> {
  @override
  void initState() {
    // TODO: implement initState
    getSavedLists();
    super.initState();
  }

  List<dynamic> clLists = [];

  getSavedLists() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    print('get full list , ${prefs.getStringList('LeadDraftLists')}');
    setState(() {
      clLists = prefs.getStringList('LeadDraftLists');
      int clLisn = clLists.length;
      print(clLisn);
    });
  }

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            MyRouter.popPage(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.blue,),
        ),

      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 5,),
              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child:   ListView.builder(
                    itemCount: clLists.length,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (index,position){
                      //  var GetSingleClient = clLists[position];
                      var getSingleClientVVV = jsonDecode(clLists[position]);
                      var singleClient  = getSingleClientVVV['moreInfo']['clients'];
                      print('single CLient ${getSingleClientVVV}');
                      return

                        InkWell(
                          onTap: (){
                            MyRouter.pushPage(context, ViewLeadDraft(clientID:position));
                          },
                          child:   _leadsContactView(Colors.redAccent, 'Lead Creation', '${singleClient['firstname']} ${singleClient['lastname']}', 'PUBLISH', 'LL')

                        );

                    }),
              )

            ],
          ),
        ),
      ),

    );
  }


  _leadsContactView(Color colm,String title,String subtitle,String date,String nameLogo){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.9),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 1),

        height: 80,
        child: Card(
          elevation: 0.3,
          child: ListTile(
            leading: _LeadingUserTile(colm,nameLogo),
            title: Text(title,style: TextStyle(color: Colors.grey,fontFamily: 'Nunito SansRegular',fontSize: 14),),
            subtitle: Text(subtitle,style: TextStyle(color:Theme.of(context).textTheme.headline6.color,fontFamily: 'Nunito SansRegular',fontSize: 15,fontWeight: FontWeight.w600),),
            trailing:  Text(date,style: TextStyle(color: Colors.grey,fontFamily: 'Nunito SansRegular',fontSize: 15),),
          ),
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
        borderRadius: BorderRadius.all(Radius.circular(10)),

      ),
      child: Center(child: Text(nameLogo,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)),
    );
  }


}
