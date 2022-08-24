import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_simple_base_project/core/constants/app_constants.dart';
import 'package:flutter_simple_base_project/core/theme/app_form_field.dart';
import 'package:flutter_simple_base_project/modules/auth/screens/button_sign_in_screen.dart';
import 'package:flutter_simple_base_project/modules/auth/screens/sign_in_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConst.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: AppFormField.inputDecorationTheme,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('vi', ''),
      ],
      home: const ButtonSignInScreen(),
    );
  }
}
