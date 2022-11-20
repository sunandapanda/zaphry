import 'package:flutter/material.dart';


//The theme class handles all the text styles,button themes,basic colors etc
ThemeData basicTheme() {
  /*TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
        fontSize: SizeConfig.twentyFiveMultiplier,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headline2: base.headline1.copyWith(
        fontSize: SizeConfig.thirtyMultiplier,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      headline3: base.headline1.copyWith(
        fontSize: SizeConfig.twentyMultiplier,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      ),
      headline4: base.headline1.copyWith(
        fontSize: SizeConfig.twentyMultiplier,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      headline5: base.headline1.copyWith(
        fontSize: SizeConfig.fifteenMultiplier,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      ),
      headline6: base.headline1.copyWith(
        fontSize: SizeConfig.fifteenMultiplier,
        color: Colors.blueGrey,
        fontWeight: FontWeight.normal,
      ),
      bodyText1: base.headline1.copyWith(
        fontSize: SizeConfig.eighteenMultiplier,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: base.headline1.copyWith(
        fontSize: SizeConfig.eighteenMultiplier,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      caption: base.headline1.copyWith(
        fontSize: SizeConfig.eighteenMultiplier,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      button: base.button.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: SizeConfig.eighteenMultiplier,
        color: Colors.white,
      ),
    );
  }*/

  final ThemeData base = ThemeData(primarySwatch: Colors.yellow);
  return base.copyWith(
    //textTheme: _basicTextTheme(base.textTheme),
    primaryColor: Colors.yellow,
    scaffoldBackgroundColor: Colors.white,
    accentColor: Colors.white,
    //buttonColor: Colors.blueGrey.shade700,
    disabledColor: Colors.grey,
    /*tabBarTheme: base.tabBarTheme.copyWith(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey,
    ),*/
  );

}
