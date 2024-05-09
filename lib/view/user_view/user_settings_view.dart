import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/app_bar_widget.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserSettingsView extends StatefulWidget {
  const UserSettingsView({super.key});

  @override
  State<UserSettingsView> createState() => _UserSettingsViewState();
}

class _UserSettingsViewState extends State<UserSettingsView> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future deleteToken() async {
    await fireStore
        .collection(AppConstants.userDataCollectionName)
        .doc(auth.currentUser!.uid)
        .update({"DeviceToken": " "});
    await auth.signOut();
  }

  Future signOutUser() async {
    try {
      deleteToken();
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.loginScreen, (route) => false);
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Settings',
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              Image.asset(
                "assets/images/commPayLogo.png",
                width: 300.w,
                height: 300.h,
              ),
              SizedBox(
                height: 60.h,
              ),
              Container(
                height: 250.h,
                width: 1.sw,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: const Offset(4, 1),
                      color: AppColors.kBlackColor.withOpacity(0.3),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    profileLisTile("Account", Icons.settings, () {}, 1.sw),
                    profileLisTile(
                        "Terms and conditions", Icons.newspaper, () {}, 1.sw),
                    profileLisTile("Logout", Icons.login_outlined, () async {
                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: const Color(0xffffffff),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            title: Center(
                              child: Text("Notice",
                                  textAlign: TextAlign.center,
                                  style: textTheme.titleMedium),
                            ),
                            actions: <Widget>[
                              Center(
                                  child: Text(
                                    "Are you sure to Log Out",
                                    style: textTheme.titleSmall,
                                  )),
                              SizedBox(
                                height: 30.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: LoginSignUpButton(
                                      title: "No",
                                      onPress: () {},
                                      width: 130.w,
                                      height: 50.h,
                                    ),
                                  ),
                                  Center(
                                    child: LoginSignUpButton(
                                      title: "Yes",
                                      onPress: () {
                                        signOutUser();
                                      },
                                      width: 130.w,
                                      height: 50.h,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ));
                    }, 1.sw),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileLisTile(
      String title, leadingIcon, onTapFunction, double width) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: const Color(0xffA8A8A8),
      ),
      title: Text(title, style: textTheme.titleMedium),
      trailing: const Icon(Icons.navigate_next, color: Color(0xffA8A8A8)),
      onTap: onTapFunction,
      contentPadding: EdgeInsets.symmetric(horizontal: width / 20),
    );
  }
}
