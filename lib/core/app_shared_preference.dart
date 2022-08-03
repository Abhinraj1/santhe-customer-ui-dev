import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreference{

  final String _login = 'isLogin';

  final String _firstTime = 'isFirstTime';

  static late SharedPreferences _appSharedPreference;

  Future<void> initSharedPreference() async => _appSharedPreference = await SharedPreferences.getInstance();

  bool get loadSignUpScreen => _appSharedPreference.getBool(_firstTime) ?? false;

  bool get checkForLogin => _appSharedPreference.getBool(_login) ?? false;

  void setLogin(bool value) => _appSharedPreference.setBool(_login, value);

  void setFirstTimeCompleted(bool value) => _appSharedPreference.setBool(_firstTime, value);

}