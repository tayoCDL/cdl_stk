import 'package:flutter/widgets.dart';

import 'package:sales_toolkit/domain/ClientsList.dart';
import 'package:sales_toolkit/util/enum/service.dart';

enum ClientState {
  Initial,
  Loading,
  Loaded,
  Error,
}

class UserModel extends ChangeNotifier {
  ClientState _homeState = ClientState.Initial;
 // List<ClientsListData> users = [];
 List<Map<ClientsListData, dynamic>> users = [];
  String message = '';

  UserModel() {
    _fetchUsers();
  }

  ClientState get homeState => _homeState;

  Future<void> _fetchUsers() async {
    _homeState = ClientState.Loading;
    try {
      await Future.delayed(Duration(seconds: 5));
      final apiusers = await ClientsApi.instance.getAllUser();
        print(apiusers);
      // users = apiusers;
      _homeState = ClientState.Loaded;
    } catch (e) {
      message = '$e';
      _homeState = ClientState.Error;
    }
    notifyListeners();
  }
}