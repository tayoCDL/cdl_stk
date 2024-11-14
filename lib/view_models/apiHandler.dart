
import 'package:geolocator/geolocator.dart';

import '../util/configsMaps.dart';
import '../util/requestAssistants.dart';


class AssistantMethods{


  static  Future<String> searchCordinateaddress(Position position) async{
    String placedAddress = '';
    var testLat = 37.43090918499161;
    var testLng = -122.07672100514174;
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    String testUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=1500&key=$mapKey";
    var response = await RequestAssistant.getRequest(url);
    var testresponse  = await RequestAssistant.getRequest(testUrl);

    if (response != 'failed') {
      placedAddress = response['results'][0]['formatted_address'];
    }
    print('this is testResponse ${testresponse}');

    return placedAddress;
  }


  static  Future<String> searchRealCordinateaddress(var latitude,var longitude) async{
    print('latitude ${latitude} and ${longitude}');
    String newplacedAddress = '';
    var testLat = 37.43090918499161;
    var testLng = -122.07672100514174;
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${testLat},${testLng}&key=$mapKey';

    var response = await RequestAssistant.getRequest(url);

    if (response != 'failed') {
      newplacedAddress = response['results'][0]['formatted_address'];
    }
    return newplacedAddress;
  }

}