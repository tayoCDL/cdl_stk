import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sales_toolkit/models/category.dart';
import 'package:sales_toolkit/util/api.dart';
import 'package:sales_toolkit/util/enum/api_request_status.dart';
import 'package:sales_toolkit/util/functions.dart';

class HomeProvider with ChangeNotifier {
  // CategoryFeed top = CategoryFeed();
  // CategoryFeed recent = CategoryFeed();
  APIRequestStatus apiRequestStatus = APIRequestStatus.loading;
  Api api = Api();

  // getFeeds() async {
  //   setApiRequestStatus(APIRequestStatus.loading);
  //   try {
  //     CategoryFeed popular = await api.getCategory(Api.popular);
  //     setTop(popular);
  //     CategoryFeed newReleases = await api.getCategory(Api.recent);
  //     setRecent(newReleases);
  //     setApiRequestStatus(APIRequestStatus.loaded);
  //   } catch (e) {
  //     checkError(e);
  //   }
  // }

  void checkError(e) {
    if (Functions.checkConnectionError(e)) {
      setApiRequestStatus(APIRequestStatus.connectionError);
    } else {
      setApiRequestStatus(APIRequestStatus.error);
    }
  }

  void setApiRequestStatus(APIRequestStatus value) {
    apiRequestStatus = value;
    notifyListeners();
  }

  // void setTop(value) {
  //   top = value;
  //   notifyListeners();
  // }
  //
  // CategoryFeed getTop() {
  //   return top;
  // }
  //
  // void setRecent(value) {
  //   recent = value;
  //   notifyListeners();
  // }
  //
  // CategoryFeed getRecent() {
  //   return recent;
  // }
}
