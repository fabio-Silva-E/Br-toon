import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brasiltoon/src/config/custom_colors.dart';
import 'package:brasiltoon/src/pages/auth/controller/auth_controller.dart';
//import 'package:greengrocer/src/pages/auth/sign_in_screen.dart';
import 'package:brasiltoon/src/pages/common_widgets/app_name_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<AuthController>().validateToken();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Colors.white,
              //CustomColors.customSwatchColor.shade800,
              //CustomColors.customSwatchColor.shade900,
            ])),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: Image.asset('assets/logo/logo.png'),
            ),

            /* AppNameWidget(
              brasilTileColor: Colors.white,
              textSize: 40,)*/

            const SizedBox(height: 10),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
