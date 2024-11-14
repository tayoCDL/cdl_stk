import 'dart:convert';

import 'package:http/http.dart' as http;
class RequestAssistant{

  static Future<dynamic> getRequest(String url) async{
    http.Response response = await http.get(url);
    try{
      if (response.statusCode == 200) {
        String JSondata = response.body;
        var decodeData = json.decode(JSondata);

        return decodeData;
      }
      else {
        return 'failed';
      }
    }catch(e){
      return "failed";
    }

  }

}