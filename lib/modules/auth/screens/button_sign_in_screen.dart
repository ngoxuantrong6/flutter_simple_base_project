import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_base_project/router/app_pages.dart';
import 'package:flutter_simple_base_project/router/app_router.dart';

class ButtonSignInScreen extends StatelessWidget {
  const ButtonSignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("mmmmm"),
      ),
      body: Center(
        child: Container(
          height: 40,
          width: 162,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              15,
            ),
            color: Colors.blue,
          ),
          child: TextButton(
              onPressed: () {
                AppRouter.toPage(context, AppPages.Next_SignInScreen);
              },
              child: const Text(
                "Sign In Screen",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }
}
