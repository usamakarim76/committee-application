import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/app_notification.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  AppNotifications appNotifications = AppNotifications();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appNotifications.requestNotificationsPermissions();
    appNotifications.foregroundMessage();
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
          context, RouteNames.loginScreen, (route) => false);
    } else {
      getCurrentUserRole();
    }
  }

  Future getCurrentUserRole() async {
    DocumentSnapshot snapshot = await fireStore
        .collection(AppConstants.userDataCollectionName)
        .doc(auth.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      print("object");
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      if (userData['Role'] == "Admin") {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.adminBottomNavBar, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.userBottomNavBar, (route) => false);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.loginScreen, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 320.h,
              width: 290.w,
              child: Image.asset("assets/images/commPayLogo.png"),
            ),
            const LoadingWidget(
              color: AppColors.kSecondaryColor,
            )
          ],
        ),
      ),
    );
  }
}
