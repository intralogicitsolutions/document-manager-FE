import 'package:appbase/base/base_notifier.dart';
import 'package:document_manager/screen/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingViewModel extends BaseNotifier {
  @override
  void onDisposeValues() {
    // TODO: implement onDisposeValues
  }

  @override
  void onNavigated() {
    // TODO: implement onNavigated
  }

  void navigateHome() {
    Navigator.pushReplacement(baseWidget.context,
        MaterialPageRoute(builder: (context) => const Login()));
  }
}
