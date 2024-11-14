import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/enum/color_utils.dart';
import 'package:sales_toolkit/util/router.dart';
import 'package:sales_toolkit/widgets/ShimmerListLoading.dart';

import '../../view_models/CodesAndLogic.dart';


class ChangeLog extends StatefulWidget {
  final int clientID;
  const ChangeLog({Key key,this.clientID}) : super(key: key);

  @override
  _ChangeLogState createState() => _ChangeLogState(
    clientID: this.clientID
  );
}

class _ChangeLogState extends State<ChangeLog> {

  int clientID;
  List<dynamic> changeLogs = [];
  _ChangeLogState({this.clientID});
  bool loaded = false;


  getChangeLog() async{
    String changeLogUrl = AppUrl.getResidentialClient + clientID.toString() + '/update-request';
    final Future<List<dynamic>> changeLogResponse =   RetCodes().getterAPI(changeLogUrl);

    changeLogResponse.then((response) {
      if(response[0] == true){
        setState(() {
          changeLogs = response[2];
          loaded = true;
        });
     //   print('client changes ${response}');
      }
        else {
          setState(() {
            loaded = true;

          });
      }



    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getChangeLog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.BACKGROUND_COLOR,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            MyRouter.popPage(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: ColorUtils.PRIMARY_COLOR,),
        ),
        title: Text('Change Log',style: TextStyle(color: Colors.black,fontSize: 23,fontWeight: FontWeight.bold),),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [

              changeLogs.isEmpty && loaded == false ?
              ShimmerListLoading()   :
              changeLogs.isEmpty && loaded == false ? ShimmerListLoading() :
              Container(
                height: MediaQuery.of(context).size.height * 0.94,
                child: ListView.builder(
                    itemCount: changeLogs.length,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (index,position){

                     return accordionChangeLog(changeLogs[position],changeLogs[position]['history']);
                }
                ),
              )

            ],
          ),
        ),
      ),
    );
  }


  Widget accordionChangeLog(var changeLog,var history){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 7),

      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white
      ),
      child: ExpansionTile(
        backgroundColor: Colors.white,
        title: ListTile(
          title: Container(

            padding: EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Text('#${changeLog['id']}',style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.bold),),
                SizedBox(width: 16,),
                clientStatus('${changeLog['status']}', ColorUtils.CHANGE_LOG_APP_COLOR, ),
                SizedBox(height: 50,)
              ],
            ),
          ),
          subtitle: Text('Initiated by ${changeLog['submittedBy']['firstname']} ${changeLog['submittedBy']['lastname']} on  ${changeLog['submittedOnDate'].toString().substring(0,10)}',style: TextStyle(color: Colors.black),),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Divider(color: ColorUtils.TEXT_COLOR,thickness: 0.4,),

                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                    color: Colors.white,
                      border: Border.all(color: ColorUtils.CHANGE_LOG_BORDER_COLOR,width: 1)
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Field',style: TextStyle(color: ColorUtils.CHANGE_LOG_TITLE,fontWeight: FontWeight.bold,fontSize: 16),),
                            Text('Old Value',style: TextStyle(color: ColorUtils.CHANGE_LOG_TITLE,fontWeight: FontWeight.bold,fontSize: 16),),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                         height: MediaQuery.of(context).size.height * 0.20,
                        child: ListView.builder(
                            itemCount: history.length,
                            itemBuilder: (index,position){
                              return   singleValues(propertyName: '${chopOff(history[position]['fieldName'])}',
                                  valueName: '${ history[position]['oldValueDescription']  == null ?
                                  history[position]['oldValue'] :  history[position]['oldValueDescription'] }');
                            }

                        ),
                      ),
                      
                     Divider(),

                      SizedBox(height: 10,)


                    ],
                  )
                ),
                SizedBox(height: 20,),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                        color: Colors.white,
                        border: Border.all(color: ColorUtils.CHANGE_LOG_BORDER_COLOR,width: 1)
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Field',style: TextStyle(color: ColorUtils.CHANGE_LOG_TITLE,fontWeight: FontWeight.bold,fontSize: 16),),
                              Text('New Value',style: TextStyle(color: ColorUtils.CHANGE_LOG_TITLE,fontWeight: FontWeight.bold,fontSize: 16),),
                            ],
                          ),

                        ),
                        Divider(),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          child: ListView.builder(
                              itemCount: history.length,
                              itemBuilder: (index,position){
                                return   singleValues(propertyName: '${chopOff(history[position]['fieldName'])}',valueName: '${
                                    history[position]['newValueDescription'] == null ?   history[position]['newValue'] :   history[position]['newValueDescription']

                                }');
                              }

                          ),
                        ),
                        Divider(),



                        SizedBox(height: 10,)


                      ],
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget clientStatus(String status,Color textColor) {
   Color cols =  status == 'REJECTED' ? ColorUtils.REJECTED_COLOR : status == 'PENDING' ? ColorUtils.PENDING_COLOR : ColorUtils.CHANGE_LOG_APP_COLOR;
   Color tColor =  status == 'REJECTED' ? ColorUtils.REJECTED_TEXT : status == 'PENDING' ? ColorUtils.PENDING_TEXT : ColorUtils.CHANGE_LOG_APP_COLOR_WITH_OPACITY;

   return Container(
      width: 85,
      height: 27,
      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cols,
        boxShadow: [
          BoxShadow(color: cols, spreadRadius: 0.1),
        ],
      ),
      child: Center(child: Text(status,style: TextStyle(color: tColor,fontSize: 13),)),
    );
  }

  Widget NoCliientRecord(){
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.27),
            SvgPicture.asset("assets/images/no_loan.svg",
              height: 90.0,
              width: 90.0,),
            SizedBox(height: 20,),
            Text('No Records, yet.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 6,),
            Text('Kindly check back',style: TextStyle(color: Colors.black,fontSize: 14,),),
            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }



  Widget singleValues({String propertyName, String valueName}){
    return  Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(propertyName,style: TextStyle(color: ColorUtils.CHANGE_LOG_TITLE,fontWeight: FontWeight.w200,fontSize: 14),),
          Text(valueName,style: TextStyle(color: ColorUtils.CHANGE_LOG_TITLE,fontWeight: FontWeight.w200,fontSize: 14),),

        ],
      ),

    );
  }

  String chopOff(String field){
      if(field.contains(':')) {
        String ob = field;
        String newOb = ob
            .split(':')
            .last;
        return newOb;
      }
      else {
        return field;
      }
      // if(newOb.contains('->')){
      //   String newSplit  = newOb.split('->').last;
      //   return newSplit;
      // }
      // else {
      //   return newOb;
      // }
      // }
      // else {
      //   return field;
      // }
  }
}
