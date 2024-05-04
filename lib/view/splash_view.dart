import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        checkLogin();
      },
    );
  }

  void checkLogin() {
    if (auth.currentUser == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.forgotPasswordScreen, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.adminDashBoardScreen, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: Center(
        child: LoadingWidget(
          color: AppColors.kSecondaryColor,
        ),
      ),
    );
  }
}
