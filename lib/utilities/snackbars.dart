import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toasts {
  static void showNormalSnackbar(String content) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showErrorSnackBar(String content) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showNoInternetConnectionSnackBar() {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: 'No internet connection.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
