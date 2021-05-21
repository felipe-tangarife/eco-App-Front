import 'dart:convert';

import 'package:eco_app3/constants/api_constant.dart';
import 'package:eco_app3/constants/colors.dart';
import 'package:eco_app3/services/auth.dart';
import 'package:eco_app3/utils/form.dart';
import 'package:eco_app3/utils/list_item.dart';
import 'package:eco_app3/utils/validators.dart';
import 'package:eco_app3/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = new GlobalKey<FormState>();

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final TextEditingController idController = new TextEditingController();
  final TextEditingController firstNameController = new TextEditingController();
  final TextEditingController lastNameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController vehicleTypeController =
      new TextEditingController();
  final TextEditingController licensePlateController =
      new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController passwordConfirmController =
      new TextEditingController();

  bool _hidePassword1, _hidePassword2;
  double _sizeBoxHeight = 25;
  AuthService _authService;

  List<ListItem> _idsItems = [
    ListItem(1, "C.C."),
    ListItem(2, "T.I."),
    ListItem(3, "R.C."),
    ListItem(4, "C.E.")
  ];

  List<DropdownMenuItem<ListItem>> _dropdownIdsItems;
  ListItem _selectedIdsItem;

  @override
  void initState() {
    _authService = new AuthService();
    _hidePassword1 = true;
    _hidePassword2 = true;
    _dropdownIdsItems = buildDropDownMenuItems(_idsItems);
    _selectedIdsItem = _dropdownIdsItems[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nameField = textFormCapitalize(
        context, null, "Nombre", validateText, firstNameController, true);

    final lastNameField = textFormCapitalize(
        context, null, "Apellido", validateText, lastNameController, true);

    final idsField = dropDownButtonForm(
        "Tipo de documento", _selectedIdsItem, _dropdownIdsItems, (value) {
      setState(() {
        _selectedIdsItem = value;
      });
    });

    final identificationField = textFormNumber(
        context, null, "Número de documento", validateText, idController, true);

    final emailField = textFormCapitalize(
        context, null, "Correo electrónico", validateText, emailController, true);

    final vehicleField = textFormCapitalize(context, null, "Tipo de vehículo",
        validateText, vehicleTypeController, true);

    final licensePlateFiled = textFormUppercase(context, null, "Matrícula",
        validateLicensePlate, licensePlateController, true);

    final passwordField = textFormPassword(
        context,
        null,
        "Contraseña",
        validatePassword,
        passwordController,
        true,
        _hidePassword1,
        () => setState(() => _hidePassword1 = !_hidePassword1));

    String confirmPassword(password) {
      if (passwordController.text != password) {
        return "Las contraseñas deben ser iguales";
      }
      return null;
    }

    final confirmPasswordField = textFormPassword(
        context,
        null,
        "Confirmar contraseña",
        confirmPassword,
        passwordConfirmController,
        true,
        _hidePassword2,
        () => setState(() => _hidePassword2 = !_hidePassword2));

    register() async {
      final form = formKey.currentState;
      form.save();
      if (form.validate()) {
        Map data = {
          'cedula': idController.text,
          'nombre': firstNameController.text,
          'apellidos': lastNameController.text,
          'correo': emailController.text,
          'password': passwordController.text,
        };
        try {
          var response =
              await _authService.register(ApiConstant.REGISTER_URL, data);
          if (response.statusCode == 200) {
            //TODO: Process the response.
            debugPrint('Register response: ' + json.decode(response.body));
            _btnController.success();
            Navigator.pushNamed(context, 'loading');
            buildSnackBar(context, "Exitoso", "Usuario creado exitosamente");
          } else if (response.statusCode == 409) {
            buildSnackBar(context, "Error", "El usuario ya existe");
            _btnController.stop();
          } else {
            buildSnackBar(context, "Error", "Error inesperado");
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Styles.PRIMARY_COLOR,
          centerTitle: true,
          title: Text("Eco App"),
        ),
        backgroundColor: Styles.SECONDARY_COLOR,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Crea una cuenta",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: _sizeBoxHeight),
                        nameField,
                        SizedBox(height: _sizeBoxHeight),
                        lastNameField,
                        SizedBox(height: _sizeBoxHeight),
                        idsField,
                        SizedBox(height: _sizeBoxHeight),
                        identificationField,
                        SizedBox(height: _sizeBoxHeight),
                        emailField,
                        SizedBox(height: _sizeBoxHeight),
                        vehicleField,
                        SizedBox(height: _sizeBoxHeight),
                        licensePlateFiled,
                        SizedBox(height: _sizeBoxHeight),
                        passwordField,
                        SizedBox(height: _sizeBoxHeight),
                        confirmPasswordField,
                        SizedBox(height: _sizeBoxHeight + 5),
                        loadingButton(
                            _btnController, "Registro".toUpperCase(), register),
                        SizedBox(height: 5.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
