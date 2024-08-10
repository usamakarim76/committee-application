import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/app_bar_widget.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/components/no_data_available_widget.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:committee_app/view/admin_view/admin_member_details_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class AdminCommitteeMemberDetailsView extends StatefulWidget {
  const AdminCommitteeMemberDetailsView({super.key});

  @override
  State<AdminCommitteeMemberDetailsView> createState() =>
      _AdminCommitteeMemberDetailsView();
}

class _AdminCommitteeMemberDetailsView
    extends State<AdminCommitteeMemberDetailsView> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(AppConstants.adminCommittee)
            .doc(auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: LoadingWidget(
                color: AppColors.kSecondaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Scaffold(
              appBar: const AppBarWidget(
                title: "Committee Members",
                check: true,
              ),
              backgroundColor: AppColors.kPrimaryColor,
              body: Container(
                width: 1.sw,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.kWhiteColor,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: const Offset(4, 1),
                      color: AppColors.kBlackColor.withOpacity(0.3),
                    )
                  ],
                ),
                child: snapshot.data!.data()!['members_list'].length == 0
                    ? Center(
                        child: Text(
                          "Members are not added yet",
                          style: textTheme.titleMedium!.copyWith(
                              fontSize: 15.sp, color: AppColors.kBlackColor),
                        ),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          String memberUid =
                              snapshot.data!.data()!['members_list'][index];
                          return FutureBuilder(
                            future: fireStore
                                .collection(AppConstants.userDataCollectionName)
                                .doc(memberUid)
                                .get(),
                            builder: (context, userSnapshot) {
                              if (!userSnapshot.hasData) {
                                return const Center(
                                  child: LoadingWidget(
                                      color: AppColors.kSecondaryColor),
                                );
                              } else if (userSnapshot.hasError) {
                                return Text(userSnapshot.error.toString());
                              } else {
                                var userData = userSnapshot.data!.data();
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AdminMemberDetailsView(
                                                userUid: memberUid),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 1.sw,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.kBlackColor
                                            .withOpacity(0.5),
                                      ),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 10.h),
                                    margin: EdgeInsets.only(bottom: 15.h),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              userData!['ProfileImage'] == ""
                                                  ? null
                                                  : NetworkImage(
                                                      userData['ProfileImage'],
                                                    ),
                                          radius: 45.r,
                                          child: userData['ProfileImage'] == ""
                                              ? Text(
                                                  "No image",
                                                  style: textTheme.titleMedium!
                                                      .copyWith(
                                                          fontSize: 10.sp),
                                                )
                                              : null,
                                        ),
                                        20.horizontalSpace,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Name: ${userData['Name']}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: textTheme.titleSmall,
                                            ),
                                            Text(
                                              "Ph.no: ${userData['PhoneNumber']}",
                                              style: textTheme.titleSmall,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                        itemCount:
                            snapshot.data!.data()!['members_list'].length,
                      ),
              ),
            );
          }
        });
  }
}
