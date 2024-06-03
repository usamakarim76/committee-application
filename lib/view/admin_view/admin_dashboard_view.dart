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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class AdminDashBoardView extends StatefulWidget {
  const AdminDashBoardView({super.key});

  @override
  State<AdminDashBoardView> createState() => _AdminDashBoardViewState();
}

class _AdminDashBoardViewState extends State<AdminDashBoardView> {
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
            return Scaffold(
              appBar: const AppBarWidget(title: "My Committees"),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.data()!['committee_name'],
                        style: textTheme.titleMedium!.copyWith(fontSize: 20.sp),
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
                      Text(
                        "Committee Members",
                        style: textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: 200.h,
                        width: 1.sw,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Text(
                                snapshot.data!.data()!['members_list'][index]);
                          },
                          itemCount:
                              snapshot.data!.data()!['members_list'].length,
                        ),
                      ),
                      Text(
                        "Payment received by committee members",
                        style: textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: 200.h,
                        width: 1.sw,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Text(
                                snapshot.data!.data()!['members_list'][index]);
                          },
                          itemCount:
                              snapshot.data!.data()!['members_list'].length,
                        ),
                      ),
                    ],
                  ),
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
