import 'package:shared_preferences/shared_preferences.dart';



Future<void> saveStringLogin(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('myStringKey', value);
}

Future<String> getStringLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('myStringKey') ?? '';
}






















Future<void> saveStringData(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('myStringKey', value);
}

Future<String> getStringData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('myStringKey') ?? '';
}

Future<void> saveStringListData(List<String> values) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('myStringListKey', values);
}

Future<List<String>> getStringListData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('myStringListKey') ?? [];
}
