import 'package:printnotes/main.dart';

class UserFirstTime {
  static void setShowIntro(bool showIntro) {
    App.localStorage.setBool('firstTimeUser', showIntro);
  }

  static bool get getShowIntro {
    return App.localStorage.getBool('firstTimeUser') ?? true;
  }
}
