import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/app_bar_widget.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/components/no_data_available_widget.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserNotificationView extends StatefulWidget {
  const UserNotificationView({super.key});

  @override
  State<UserNotificationView> createState() => _UserNotificationViewState();
}

class _UserNotificationViewState extends State<UserNotificationView> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Notifications"),
      backgroundColor: AppColors.kPrimaryColor,
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: StreamBuilder(
            stream: fireStore
                .collection(AppConstants.notification)
                .doc(auth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LoadingWidget(
                  color: AppColors.kSecondaryColor,
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.data!.data()!.isEmpty) {
                return NoDataAvailableWidget(
                  isButton: true,
                  onTap: () {
                    model.updateData();
                  },
                );
                );
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        height: 80.h,
                        width: 1.sw,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: AppColors.kWhiteColor,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 0,
                              offset: const Offset(4, 1),
                              color: AppColors.kBlackColor.withOpacity(0.3),
                            )
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            snapshot.data!.data()!['notification'][index],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium!
                                .copyWith(fontSize: 15.sp),
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.data()!.length,
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
    );
  }
}
