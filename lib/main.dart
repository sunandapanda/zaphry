import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zaphry/View/Screens/SplashScreen.dart';

import 'Model/SharedPrefs.dart';
import 'View/Model/SizeConfig.dart';
import 'View/Model/basicTheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: MaterialApp(
                title: 'Zaphry',
                theme: basicTheme(),
                builder: EasyLoading.init(),
                home: SplashScreen(),
              ),
            );
          },
        );
      },
    );
  }
}
