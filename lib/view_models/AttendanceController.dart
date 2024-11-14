
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../util/app_url.dart';

class AttendanceProvider extends ChangeNotifier {

  notify(){
    notifyListeners();
  }



  Future<Map<String, dynamic>> addAttendance(var attendanceData,String url) async {
    var result;

    print('sign In ${attendanceData}');

    try {
      Response response = await post(
        url,
        body: json.encode(attendanceData),
        headers: {
          'Content-Type': 'application/json',
           },
      );

        print(response.statusCode);

      if(response.statusCode == 200 ){
        final Map<String, dynamic> responseData2 = json.decode(response.body);
        print(responseData2);

        result = {'status': true, 'message': 'Successful','data':responseData2};


      }
      else {
        result = {
          'status': false,
          'message': json.decode(response.body)
        };
      }
    }
    catch(e){
     print(e);
     return result = {'status': false, 'message': 'Network_error','data':'No Internet connection'};

    }

    return result;

  }

  Future<Map<String, dynamic>> addAttendancGet(String url,String params) async {
    var result;
    try {
      Response response = await get(
        url + params,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print(response.statusCode);

      if(response.statusCode == 200 ){
        final Map<String, dynamic> responseData2 = json.decode(response.body);
        print(responseData2);

        result = {'status': true, 'message': 'Successful','data':responseData2};


      }
      else {
        result = {
          'status': false,
          'message': json.decode(response.body)
        };
      }
    }
    catch(e){
      print(e);
      return result = {'status': false, 'message': 'Network_error','data':'No Internet connection'};

    }

    return result;

  }



}