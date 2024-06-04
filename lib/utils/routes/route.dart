import 'package:committee_app/utils/routes/route_name.dart';
import 'package:committee_app/view/admin_view/admin_account_update.dart';
import 'package:committee_app/view/admin_view/admin_add_committee_view.dart';
import 'package:committee_app/view/admin_view/admin_dashboard_view.dart';
import 'package:committee_app/view/admin_view/admin_member_details_view.dart';
import 'package:committee_app/view/admin_view/admin_signup_view.dart';
import 'package:committee_app/view/admin_view/admin_bottom_navigation_bar.dart';
import 'package:committee_app/view/forgot_password_view.dart';
import 'package:committee_app/view/login_view.dart';
import 'package:committee_app/view/terms_and_conditions_view.dart';
import 'package:committee_app/view/user_view/user_bottom_navigation_bar.dart';
import 'package:committee_app/view/user_view/user_dashboard_view.dart';
import 'package:committee_app/view/user_view/user_signup_view.dart';
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
      case RouteNames.userSignUpScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UserSignUpView());
      case RouteNames.adminSignUpScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AdminSignUpView());
      case RouteNames.forgotPasswordScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ForgotPasswordView());
      case RouteNames.adminDashBoardScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AdminDashBoardView());
      case RouteNames.userDashBoardScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UserDashBoardView());
      case RouteNames.adminBottomNavBar:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                const AdminBottomNavigationBar());
      case RouteNames.userBottomNavBar:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UserBottomNavigationBar());
      case RouteNames.adminAddCommitteeScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AdminAddCommitteeView());
      case RouteNames.adminAccountUpdateScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AdminAccountUpdateView());
      case RouteNames.termsAndConditions:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TermsAndConditionsView());
      case RouteNames.adminMemberDetailsView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AdminMemberDetailsView());
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Text("No Route"),
          );
        });
    }
  }
}
