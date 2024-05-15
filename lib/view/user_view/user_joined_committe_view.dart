import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/app_bar_widget.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/view_model/user_view_model/join_committee_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserJoinedCommitteeView extends StatefulWidget {
  const UserJoinedCommitteeView({super.key});

  @override
  State<UserJoinedCommitteeView> createState() =>
      _UserJoinedCommitteeViewState();
}

class _UserJoinedCommitteeViewState extends State<UserJoinedCommitteeView> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UserJoinCommitteeViewModel(context),
      child: Consumer<UserJoinCommitteeViewModel>(
        builder: (BuildContext context, UserJoinCommitteeViewModel model,
                Widget? child) =>
            Scaffold(
          appBar: const AppBarWidget(title: "Committees"),
          backgroundColor: AppColors.kPrimaryColor,
          body: StreamBuilder(
              stream:
                  fireStore.collection(AppConstants.adminCommittee).snapshots(),
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
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    height: 1.sh,
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        DateTime startDate = DateFormat('dd/MM/yyyy').parse(
                            snapshot.data!.docs[index]['committee_start_date']);
                        DateTime endDate = DateFormat('dd/MM/yyyy').parse(
                            snapshot.data!.docs[index]['committee_end_date']);
                        // Calculate the difference in months
                        int differenceInMonths =
                            _calculateDifferenceInMonths(startDate, endDate);

                        return InkWell(
                          onTap: () {
                            print(snapshot.data!.docs[index]);
                          },
                          child: Container(
                            height: 160.h,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]
                                          ['committee_name'],
                                      style: textTheme.titleMedium!
                                          .copyWith(fontSize: 20.sp),
                                    ),
                                    Text(
                                      "Members : ${snapshot.data!.docs[index]['members_list'].length}/${snapshot.data!.docs[index]['number_of_members']}",
                                      style: textTheme.titleMedium,
                                    ),
                                    Text(
                                      "Duration : $differenceInMonths months",
                                      style: textTheme.titleMedium,
                                    ),
                                    Text(
                                      "Total amount : ${snapshot.data!.docs[index]['total_amount']}",
                                      style: textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                                LoginSignUpButton(
                                  title: "Join",
                                  onPress: () {
                                    print(
                                        snapshot.data!.docs[index]['user_uid']);
                                    model.getCurrentUserData(snapshot
                                        .data!.docs[index]['user_uid']
                                        .toString());
                                  },
                                  width: 120.w,
                                  height: 45.h,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 20.h,
                        );
                      },
                    ),
                  );
                }
              }),
        ),
      ),
    );
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
