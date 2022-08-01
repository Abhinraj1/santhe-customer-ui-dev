import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreference{

  static String _login = 'isLogin';

  static String _firstTime = 'isFirstTime';

  static late SharedPreferences appSharedPreference;

  Future<void> initSharedPreference() async => appSharedPreference = await SharedPreferences.getInstance();

  bool get loadOnBoardingScreens => appSharedPreference.getBool(_firstTime) ?? false;

  bool get checkForLogin => appSharedPreference.getBool(_login) ?? false;

  void setLogin(bool value) => appSharedPreference.setBool(_login, value);

}