import 'package:flutter/material.dart';
import 'package:flutter_simple_base_project/modules/auth/viewmodel/sign_in_viewmodel.dart';
import 'package:flutter_simple_base_project/utils/helpers/validator.dart';
import 'package:flutter_simple_base_project/widgets/text_field_show.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _invisible = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<LoginModel>().addListener(_updateUI);
  }

  _updateUI() => setState(() {});

  @override
  void dispose() {
    context.read<LoginModel>().removeListener(_updateUI);
    super.dispose();
  }

  _handleLoginButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      if (await context.read<LoginModel>().login()) {
        // Navigator to next screen
        () {};
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<LoginModel>();

    return Scaffold(
        appBar: AppBar(
          title: Text("nnnnnn"),
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Đăng nhập",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black38,
                  ),
                ),
                if (model.state == LoginViewState.loginFalied)
                  Text(
                    model.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tài khoản"),
                        TextFieldShow(
                          comment: false,
                          readOnly: model.state == LoginViewState.loading,
                          listener: model.email,
                          validator: Validator.requiredInputEmailValidator,
                          hint: "Nhập email",
                        ),
                        const SizedBox(height: 20),
                        const Text("Mật khẩu"),
                        TextFieldShow(
                          comment: false,
                          readOnly: model.state == LoginViewState.loading,
                          hint: "Nhập mật khẩu",
                          validator: Validator.inputPasswordValidator,
                          obscureText: _invisible,
                          listener: model.password,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _invisible = !_invisible;
                                });
                              },
                              child: Icon(
                                _invisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (model.state == LoginViewState.loading)
                          const Center(child: CircularProgressIndicator())
                        else
                          Align(
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
                                onPressed: _handleLoginButtonPressed,
                                child: const Text(
                                  "Đăng nhập",
                                  style: TextStyle(color: Colors.white),
                                )),
                          )),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
