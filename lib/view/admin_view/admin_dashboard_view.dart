import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AdminDashBoardView extends StatefulWidget {
  const AdminDashBoardView({super.key});

  @override
  State<AdminDashBoardView> createState() => _AdminDashBoardViewState();
}

class _AdminDashBoardViewState extends State<AdminDashBoardView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future signOutUser() async {
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.loginScreen, (route) => false);
      } else {
        await auth.signOut();
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.loginScreen, (route) => false);
      }
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin",
          style: textTheme.titleMedium,
        ),
        centerTitle: true,
        backgroundColor: AppColors.kPrimaryColor,
        actions: [
          IconButton(
              onPressed: () {
                signOutUser();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: StreamBuilder(
          stream: firestore
              .collection(AppConstants.userDataCollectionName)
              .doc(auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                "Error ${snapshot.error}",
                style: textTheme.titleMedium!.copyWith(
                  fontSize: 25.sp,
                ),
              );
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(
                  child: LoadingWidget(
                color: AppColors.kSecondaryColor,
              ));
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.data!.get('Name'),
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 25.sp,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      snapshot.data!.get('Email'),
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
