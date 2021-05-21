import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eco_app3/constants/colors.dart';

buildSnackBar(BuildContext context, title, message) {
  return Flushbar(
    titleText: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        // fontFamily: 'Corporate-condensed-light',
      ),
    ),
    messageText: Text(
      message,
      style: TextStyle(
        color: Colors.white,
        // fontFamily: 'Corporate-condensed-light',
      ),
    ),
    duration: Duration(seconds: 6),
    leftBarIndicatorColor: Styles.PRIMARY_COLOR,
  ).show(context);
}