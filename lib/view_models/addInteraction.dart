import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sales_toolkit/domain/user.dart';

import 'package:http/http.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum uStatus {
  NotSent,
  Sent,
  Sending,
}

class AddInteractionProvider extends ChangeNotifier {
  uStatus _addStatus = uStatus.NotSent;

  uStatus get addStatus => _addStatus;

  set addStatus(uStatus value) {
    _addStatus = value;
  }


  notify(){
    notifyListeners();
  }

  static Future<FutureOr> onValue (Response response) async {
    var result ;

    final Map<String, dynamic> responseData = json.decode(response.body);

    // print(responseData);

    if(response.statusCode == 200){

      var userData = responseData['data'];

      // now we will create a user model
      User authUser = User.fromJson(responseData);

      // now we will create shared preferences and save data
      UserPreferences().saveUser(authUser);

      result = {
        'status':true,
        'message':'Successfully registered',
        'data':authUser
      };

    }else{
      result = {
        'status':false,
        'message':'Successfully registered',
        'data':responseData
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> addInteraction(var interactionData,String url) async {
    var result;

    _addStatus = uStatus.NotSent;
    notifyListeners();

    print(interactionData);
    print('interaction Data');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String Vusername = prefs.getString('username');
    print(prefs);
    print('this url >> ${url}');
    //   January 24, 1991

    final Map<String, dynamic> clientData = {
      "subject": interactionData['subject'],
      "description": interactionData['description'],
      "affectedPartyName": interactionData['affectedPartyName'],
      "clientId":interactionData['clientId'] ,
      "affectedPartyEmail": interactionData['affectedPartyEmail'],
      "requestingParty": interactionData['requestingParty'],
      "affectedTypeId": interactionData['affectedTypeId'],
      "requestTypeId": interactionData['requestTypeId'],
      "categoryId": interactionData['categoryId'],
      "subCategoryId": interactionData['subCategoryId'],
      "hasAttachment": interactionData['hasAttachment'],
      "fileName": interactionData['fileName'],
      "fileSize": interactionData['fileSize'],
      "attachment":interactionData['attachment'],
     // "createdBy": prefs.getString('key'),
      "createdBy": interactionData['createdBy'],
    //  "createdById": prefs.getString('username'),
      "createdById": interactionData['createdById'],
      "createdByEmail": Vusername,
      "responsibleUnitId": interactionData['responsibleUnitId'],
      "closeTicket": false,
      "escalateRequest": {
        "escalateRequest": false,
        "responsibleUnitId": interactionData['responsibleUnitId']
      }
    };




    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    var sequesttoken = prefs.getString('sequestToken');
    var clientId = prefs.getInt('clientId');
    print(clientId);
    print('interactionData ${interactionData}');


    try{
      _addStatus = uStatus.Sending;
      Response responsevv = await post(
        url,
        body: json.encode(interactionData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${sequesttoken}',
        },
      );
      print(responsevv.statusCode);
      print(responsevv.body);
      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {'status': false, 'message': 'Network error','data':'No Internet connection'};

      }

      if(responsevv.statusCode == 200 ){
        final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
        notifyListeners();


        result = {'status': true, 'message': 'Successful','data':responseData2};


      }
      else {
        _addStatus = uStatus.Sent;
        notifyListeners();
        _addStatus = uStatus.NotSent;
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(responsevv.body)
        };
      }

    }
    catch(e){

      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {'status': false, 'message': 'Network error','data':'No Internet connection'};

      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;

  }

  Future<Map<String, dynamic>> replyTicket(var interactionData) async {
    var result;

    _addStatus = uStatus.NotSent;
    notifyListeners();

    print(interactionData);
    print('interaction Data');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs);

    //   January 24, 1991

    final Map<String, dynamic> intData = {
      "ticketId": interactionData['ticketId'],
      "messageBody": interactionData['messageBody'],
      "unitId": 0,
      "fileName": "",
      "attachment": "",
      "fileSize": "",
      "createdBy": "",
      "createdById": "",
      "requestStatus": 0
    };




    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');
    var sequesttoken = prefs.getString('sequestToken');
    var clientId = prefs.getInt('clientId');
    print(sequesttoken);
    print(token);


    try{
      _addStatus = uStatus.Sending;
      Response responsevv = await post(
        AppUrl.replyTicket,
        body: json.encode(interactionData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${sequesttoken}',
        },
      );
      print(responsevv.statusCode);
      print(responsevv.body);
      var e = responsevv.body;
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        result = {'status': false, 'message': 'Network error','data':'No Internet connection'};

      }

      if(responsevv.statusCode == 200 ){
        final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
        notifyListeners();
        result = {'status': true, 'message': 'Successful','data':responseData2};

      }
      else {

        _addStatus = uStatus.Sent;
        notifyListeners();
        _addStatus = uStatus.NotSent;
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(responsevv.body)
        };
      }

    }
    catch(e){
    print('>>< ${e.toString()}');
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        return result = {'status': false, 'message': 'Network error','data':'No Internet connection'};

      } else {
        // result = {'status': false, 'message': 'Successful','data':responseData2};

      }
    }

    return result;

  }



  static onError(error){
    print('the error is ${error.detail}');
    return {
      'status':false,
      'message':'Unsuccessful Request',
      'data':error
    };
  }


}