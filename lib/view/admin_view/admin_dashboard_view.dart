import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/app_bar_widget.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/components/no_data_available_widget.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AdminDashBoardView extends StatefulWidget {
  const AdminDashBoardView({super.key});

  @override
  State<AdminDashBoardView> createState() => _AdminDashBoardViewState();
}

class _AdminDashBoardViewState extends State<AdminDashBoardView> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String selectedUser = "";
  List<dynamic> usernames = [];
  Future<void> checkAndClearPaidMembers() async {
    DateTime now = DateTime.now();
    if (now.day == 11) {
      DocumentReference committeeDoc = fireStore
          .collection(AppConstants.adminCommittee)
          .doc(auth.currentUser!.uid);
      await committeeDoc.update({'committee_paid_by_members': []});
    }
  }

  void selectRandomUser() async {
    if (usernames.isNotEmpty) {
      final randomIndex = Random().nextInt(usernames.length);
      final randomUser = usernames[randomIndex];

      await fireStore
          .collection(AppConstants.adminCommittee)
          .doc(auth.currentUser!.uid)
          .update({
        'this_month_committee_member_selected': randomUser,
      });
      await fireStore
          .collection(AppConstants.adminCommittee)
          .doc(auth.currentUser!.uid)
          .update({
        'committee_members_name': FieldValue.arrayRemove([randomUser])
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndClearPaidMembers();
  }

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
          } else if (!snapshot.data!.exists) {
            return Center(
              child: NoDataAvailableWidget(
                isButton: true,
                onTap: () {
                  Navigator.pushNamed(
                      context, RouteNames.adminAddCommitteeScreen);
                },
                title: "Create Committee",
                height: 50.h,
                width: 200.w,
              ),
            );
          } else {
            DateTime startDate = DateFormat('dd/MM/yyyy')
                .parse(snapshot.data!.data()!['committee_start_date']);
            DateTime endDate = DateFormat('dd/MM/yyyy')
                .parse(snapshot.data!.data()!['committee_end_date']);
            // Calculate the difference in months
            int differenceInMonths =
                _calculateDifferenceInMonths(startDate, endDate);
            print(snapshot.data!.data()!['committee_members_name']);
            usernames = snapshot.data!.data()!['committee_members_name'];
            return Scaffold(
              appBar: const AppBarWidget(title: "My Committees"),
              backgroundColor: AppColors.kPrimaryColor,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  children: [
                    Container(
                      height: 0.35.sh,
                      width: 1.sw,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 20.h),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.data()!['committee_name'],
                            style: textTheme.titleMedium!
                                .copyWith(fontSize: 20.sp),
                          ),
                          Text(
                            "Members : ${snapshot.data!.data()!['members_list'].length}/${snapshot.data!.data()!['number_of_members']}",
                            style: textTheme.titleMedium,
                          ),
                          Text(
                            "Duration : $differenceInMonths months",
                            style: textTheme.titleMedium,
                          ),
                          Text(
                            "Total amount : ${snapshot.data!.data()!['total_amount']}",
                            style: textTheme.titleMedium,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Committee Members",
                                style: textTheme.titleMedium,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context,
                                        RouteNames.committeeMembersDetail);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.kSecondaryColor,
                                    size: 30,
                                  ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Paid members",
                                style: textTheme.titleMedium,
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context,
                                      RouteNames.committeePaidByMembers);
                                },
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.kSecondaryColor,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    Container(
                      width: 1.sw,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 20.h),
                      decoration: BoxDecoration(
                        color: AppColors.kWhiteColor,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            spreadRadius: 0,
                            offset: const Offset(4, 1),
                            color: AppColors.kBlackColor.withOpacity(0.3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          usernames.isEmpty
                              ? Text(
                                  "Committee are not joined by any member yet.",
                                  style: textTheme.titleMedium,
                                )
                              : Text(
                                  "Committee members that are remaining",
                                  style: textTheme.titleMedium,
                                ),
                          20.verticalSpace,
                          usernames.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  width: 1.sw,
                                  height: 40.h,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: usernames.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.kBlackColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 5.h),
                                        child: Center(
                                          child: Text(
                                            usernames[index],
                                            style: textTheme.titleMedium!
                                                .copyWith(
                                                    color: AppColors
                                                        .kSecondaryColor),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            10.horizontalSpace,
                                  ),
                                ),
                          20.verticalSpace,
                          Text(
                            snapshot.data!.data()![
                                        'this_month_committee_member_selected'] ==
                                    ""
                                ? "No user selected yet for this month Committee."
                                : "Selected user for this month's committee :",
                            style: textTheme.titleMedium,
                          ),
                          10.verticalSpace,
                          Center(
                            child: Text(
                              snapshot.data!.data()![
                                  'this_month_committee_member_selected'],
                              style: textTheme.titleLarge,
                            ),
                          ),
                          30.verticalSpace,
                          LoginSignUpButton(
                            title: "Select Random Member",
                            onPress: selectRandomUser,
                            width: 1.sw,
                            height: 50.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  int _calculateDifferenceInMonths(DateTime startDate, DateTime endDate) {
    int years = endDate.year - startDate.year;
    int months = endDate.month - startDate.month;
    int days = endDate.day - startDate.day;

    int totalMonths = years * 12 + months;
    if (days < 0) {
      totalMonths--;
    }
    return totalMonths;
  }
}
