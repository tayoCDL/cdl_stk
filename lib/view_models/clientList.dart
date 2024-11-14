import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sales_toolkit/domain/user.dart';

import 'package:http/http.dart';
import 'package:sales_toolkit/util/app_url.dart';
import 'package:sales_toolkit/util/headers.dart';
import 'package:sales_toolkit/util/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  NotRead,
  Read,
  Reading,
}

class ClientListProvider extends ChangeNotifier {
  Status _clientStatus = Status.NotRead;

  Status get clientStatus => _clientStatus;

  set clientStatus(Status value) {
    _clientStatus = value;
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

  Future<Map<String, dynamic>> readClient() async {
    var result;

    _clientStatus = Status.Reading;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfaToken');
    print(tfaToken);
    print(token);
    Response responsevv = await get(
      AppUrl.ClientsList,
      headers: Header().showHeader()
    );
    final Map<String, dynamic> responseData2 = json.decode(responsevv.body);
    print(responseData2);

    //2
    var clientData = responseData2;
    //User authUser = User.fromJson(userData);
  //  ClientsList clientsList = ClientsList.fromJson(clientData);
    _clientStatus = Status.Read;
    notifyListeners();

    result = {'status': true, 'message': 'Successful', 'user': ''};

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