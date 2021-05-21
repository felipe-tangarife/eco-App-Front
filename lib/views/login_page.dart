import 'dart:convert';

import 'package:eco_app3/constants/api_constant.dart';
import 'package:eco_app3/constants/colors.dart';
import 'package:eco_app3/constants/images.dart';
import 'package:eco_app3/services/auth.dart';
import 'package:eco_app3/utils/form.dart';
import 'package:eco_app3/utils/validators.dart';
import 'package:eco_app3/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final TextEditingController idController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  AuthService _authService;
  bool _hidePassword;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    _authService = new AuthService();
    _hidePassword = true;
    super.initState();
  }

  login() async {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      //TODO: Create request body.
      Map data = {
        'email': idController.text,
        'password': passwordController.text
      };
      try {
        var response = await _authService.login(ApiConstant.LOGIN_URL, data);
        if (response.statusCode == 200) {
          //TODO: Process the response.
          var jsonResponse = json.decode(response.body);

          _btnController.success();

          Navigator.pushNamed(context, 'loading');
        } else {
          buildSnackBar(context, "Error", "Credenciales incorrectas");
          _btnController.stop();
        }
      } on Exception {
        buildSnackBar(context, "Error", "Error inesperado");
        _btnController.stop();
      }
    } else {
      _btnController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.PRIMARY_COLOR,
        centerTitle: true,
        title: Text("Eco App"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Center(
                  child: Image.asset(
                    Images.LOGO_APP,
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        textFormNumber(context, Icons.email_sharp, "Email",
                            validateText, idController, true),
                        SizedBox(
                          height: 32,
                        ),
                        textFormPassword(
                            context,
                            Icons.vpn_key,
                            "Contraseña",
                            validateText,
                            passwordController,
                            true,
                            _hidePassword,
                            () =>
                                setState(() => _hidePassword = !_hidePassword)),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: loadingButton(
                              _btnController, "Ingresar".toUpperCase(), login),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No tienes cuenta?",
                                style: TextStyle(color: Styles.THIRD_COLOR)),
                            TextButton(
                                child: Text(
                                  "Registrate",
                                  style: TextStyle(color: Styles.PRIMARY_COLOR),
                                ),
                                onPressed: () {
                                  _btnController.stop();
                                  Navigator.pushNamed(context, 'register');
                                }),
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
