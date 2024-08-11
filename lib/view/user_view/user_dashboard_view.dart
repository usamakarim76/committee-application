import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/app_bar_widget.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserDashBoardView extends StatefulWidget {
  const UserDashBoardView({super.key});

  @override
  State<UserDashBoardView> createState() => _UserDashBoardViewState();
}

class _UserDashBoardViewState extends State<UserDashBoardView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "My Committees"),
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
                      snapshot.data!.get('committee_joined_by_user').first,
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
