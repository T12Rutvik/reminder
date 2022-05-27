import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reminder/core/view_model/base_view.dart';

import '../core/constant/image_constant.dart';
import '../core/routing/routes.dart';
import '../core/view_model/splash_screen_model/splash_screen_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.homeScreen, (route) => false);
      },
    );
  }

  SplashViewModel? model;
  @override
  Widget build(BuildContext context) {
    return BaseView<SplashViewModel>(
      builder: (buildContext, model, child) {
        return Scaffold(
          body: Center(
            child: Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstant.splashLogo),
                ),
              ),
            ),
          ),
        );
      },
      onModelReady: (model) async {
        this.model = model;
      },
    );
  }
}
