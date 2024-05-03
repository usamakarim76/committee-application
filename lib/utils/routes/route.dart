import 'package:committee_app/utils/routes/route_name.dart';
import 'package:committee_app/view/login_view.dart';
import 'package:committee_app/view/main_view.dart';
import 'package:committee_app/view/user_signup_view.dart';
import 'package:committee_app/view/splash_view.dart';
import 'package:flutter/material.dart';


class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());
      case RouteNames.loginScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginView());
      case RouteNames.signUpScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UserSignUpView());
      case RouteNames.mainScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MainView());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Text("No Route"),
          );
        });
    }
  }
}
