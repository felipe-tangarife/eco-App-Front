import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:eco_app3/constants/colors.dart';

InputDecoration _buildTextDecoration(
    String labelText, IconData icon, bool required) {
  return InputDecoration(
    prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
    fillColor: Colors.white,
    labelText: required ? labelText + '*' : labelText,
    labelStyle: TextStyle(color: Styles.THIRD_COLOR),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Styles.THIRD_COLOR),
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
    ),
    border:
    OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
  );
}

InputDecoration _buildPasswordDecoration(
    String labelText, IconData icon, bool required, IconButton suffixIcon) {
  return InputDecoration(
    prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
    suffixIcon: suffixIcon,
    labelText: required ? labelText + ' *' : labelText,
    labelStyle: TextStyle(color: Styles.THIRD_COLOR),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Styles.THIRD_COLOR),
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
    ),
    border:
    OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
  );
}

Widget textFormCapitalize(
    context, icon, labelText, validator, controller, required) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
    child: TextFormField(
        controller: controller,
        autofocus: false,
        textCapitalization: TextCapitalization.sentences,
        validator: validator,
        decoration: _buildTextDecoration(labelText, icon, required)),
  );
}

Widget textFormNumber(
    context, icon, labelText, validator, controller, required) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
    child: TextFormField(
        autofocus: false,
        keyboardType: TextInputType.number,
        validator: validator,
        controller: controller,
        decoration: _buildTextDecoration(labelText, icon, required)),
  );
}

Widget textFormPassword(context, icon, labelText, validator, controller,
    required, hideText, onPressed) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
    child: TextFormField(
      autofocus: false,
      obscureText: hideText,
      validator: validator,
      controller: controller,
      decoration: _buildPasswordDecoration(
        labelText,
        icon,
        required,
        IconButton(
            icon: Icon(
              hideText ? Icons.remove_red_eye : Icons.no_encryption,
              color: Styles.THIRD_COLOR,
            ),
            onPressed: onPressed),
      ),
    ),
  );
}

RoundedLoadingButton loadingButton(
    RoundedLoadingButtonController btnController, String text, onPressed) {
  return RoundedLoadingButton(
    height: 45,
    color: Styles.PRIMARY_COLOR,
    successColor: Styles.THIRD_COLOR,
    child: Text(text, style: TextStyle(color: Colors.white)),
    controller: btnController,
    onPressed: onPressed,
  );
}
