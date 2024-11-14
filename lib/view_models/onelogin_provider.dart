
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sales_toolkit/util/api.dart';
import 'package:sales_toolkit/util/enum/api_request_status.dart';

class OneLoginProvider with ChangeNotifier {

  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  Api api = Api();



}
