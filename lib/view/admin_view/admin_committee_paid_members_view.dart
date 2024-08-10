import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/components/app_bar_widget.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/colors.dart';

class AdminCommitteePaidMembersView extends StatefulWidget {
  const AdminCommitteePaidMembersView({super.key});

  @override
  State<AdminCommitteePaidMembersView> createState() =>
      _AdminCommitteePaidMembersViewState();
}

class _AdminCommitteePaidMembersViewState
    extends State<AdminCommitteePaidMembersView> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(AppConstants.adminCommittee)
            // .where('user_uid', isEqualTo: auth.currentUser!.uid)
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
              appBar: const AppBarWidget(title: "Committee paid Members"),
              backgroundColor: AppColors.kPrimaryColor,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Container(
                  height: 1.sh,
                  width: 1.sw,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
                      : snapshot.data!
                                  .data()!['committee_paid_by_members']
                                  .length ==
                              0
                          ? Center(
                              child: Text(
                                "Committee is not given by any member",
                                style: textTheme.titleMedium!.copyWith(
                                    fontSize: 15.sp,
                                    color: AppColors.kBlackColor),
                              ),
                            )
                          : SizedBox(
                              height: 210.h,
                              width: 400.w,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  String memberUid = snapshot.data!
                                          .data()!['committee_paid_by_members']
                                      [index];
                                  return FutureBuilder(
                                    future: fireStore
                                        .collection(
                                            AppConstants.userDataCollectionName)
                                        .doc(memberUid)
                                        .get(),
                                    builder: (context, userSnapshot) {
                                      if (!userSnapshot.hasData) {
                                        return const Center(
                                          child: LoadingWidget(
                                              color: AppColors.kSecondaryColor),
                                        );
                                      } else if (userSnapshot.hasError) {
                                        return Text(
                                            userSnapshot.error.toString());
                                      } else {
                                        var userData =
                                            userSnapshot.data!.data();
                                        return InkWell(
                                          onTap: () {
                                            // Navigator.pushNamed(
                                            //     context,
                                            //     RouteNames
                                            //         .adminMemberDetailsView);
                                          },
                                          child: Container(
                                            width: 1.sw,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.kBlackColor
                                                    .withOpacity(0.5),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.w,
                                                vertical: 10.h),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: userData![
                                                              'ProfileImage'] ==
                                                          ""
                                                      ? null
                                                      : NetworkImage(
                                                          userData[
                                                              'ProfileImage'],
                                                        ),
                                                  radius: 45.r,
                                                  child: userData[
                                                              'ProfileImage'] ==
                                                          ""
                                                      ? Text(
                                                          "No image",
                                                          style: textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                  fontSize:
                                                                      10.sp),
                                                        )
                                                      : null,
                                                ),
                                                20.horizontalSpace,
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Name : ${userData['Name']}",
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          textTheme.titleSmall,
                                                    ),
                                                    Text(
                                                      "Ph.no : ${userData['PhoneNumber']}",
                                                      style:
                                                          textTheme.titleSmall,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                                itemCount: snapshot.data!
                                    .data()!['committee_paid_by_members']
                                    .length,
                              ),
                            ),
                ),
              ),
            );
          }
        });
  }
}
