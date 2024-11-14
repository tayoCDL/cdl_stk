
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/constants.dart';

class AppService {
  Dio _dio;


  AppService() {
    _dio = Dio();

    // Set up request interceptors
    _dio.interceptors.add(
        InterceptorsWrapper(
      onRequest: (options)  async{
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.getString('base64EncodedAuthenticationKey');
        var tfaToken = prefs.getString('tfa-token');
     

        if(token != null){
          options.headers["Authorization"] = "Basic ${token}";
          options.headers["Fineract-Platform-TFA-Token"] = "Basic ${tfaToken}";
        }
        options.headers["Fineract-Platform-TenantId"] = FINERACT_PLATFORM_TENANT_ID;
        options.headers["Content-Type"] = 'application/json';
        options.connectTimeout = 90000;
        options.sendTimeout = 90000;
        options.receiveTimeout = 90000;
        return options;
      },
      onResponse: (response) {
        // Do something with the response
        print("Response Interceptor: ${response.statusCode} ${response.data}");
        return response.data;
    //    return handler.next(response); // Must call next(response) to continue with the response
      },
      onError: (DioError e) {
        // Do something with the error
        print("Error Interceptor: ${e.message}");

        return e;
       // return handler.next(e); // Must call next(e) to continue with the error handling
      },
    )
    );
  }

  Future<Response<dynamic>> get(String url, {Map<String, dynamic> queryParameters}) async {
    try {
      return await _dio.get(url, queryParameters: queryParameters);
    } catch (error) {
      throw Exception('Error in GET request: $error');
    }
  }

  Future<Response<dynamic>> post(String url, {Map<String, dynamic> data}) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('base64EncodedAuthenticationKey');
    var tfaToken = prefs.getString('tfa-token');

    try {
      return await _dio.post(
          url, data: json.encode(data),
      );
    } catch (error) {
      throw Exception('Error in POST request: ${error}');
    }
  }
}