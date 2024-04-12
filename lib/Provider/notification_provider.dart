import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  String id = '';
  void getId({required int id}) {
    id = id;
    notifyListeners();
  }
}
