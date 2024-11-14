import 'package:flutter/material.dart';

class ManageLoginState extends ChangeNotifier {
  bool isLoggedIn = false;

  bool get LogInStatus{
    return isLoggedIn;
  }
  void UserLoggedIn(){
    isLoggedIn = true;
    notifyListeners();
  }
  void UserNotLoggedIn(){
    isLoggedIn = false;
    notifyListeners();
  }
}
