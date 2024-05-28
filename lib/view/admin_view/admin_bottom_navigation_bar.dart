import 'package:committee_app/resources/app_notification.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/view/admin_view/admin_dashboard_view.dart';
import 'package:committee_app/view/admin_view/admin_notification_view.dart';
import 'package:committee_app/view/admin_view/admin_requests_view.dart';
import 'package:committee_app/view/admin_view/admin_settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminBottomNavigationBar extends StatefulWidget {
  const AdminBottomNavigationBar({super.key});

  @override
  State<AdminBottomNavigationBar> createState() =>
      _AdminBottomNavigationBarState();
}

class _AdminBottomNavigationBarState extends State<AdminBottomNavigationBar> {
  int pageIndex = 0;
  AppNotifications appNotifications = AppNotifications();

  final pages = [
    const AdminDashBoardView(),
    const AdminRequestView(),
    const AdminNotificationView(),
    const AdminSettingsView()
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appNotifications.firebaseNotificationsInitialization(context);
    appNotifications.setUpInteractMessage(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
      height: 64.h,
      width: 370.w,
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor,
        borderRadius: BorderRadius.circular(60.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.home,
                      color: AppColors.kBlackColor,
                    )
                  : const Icon(
                      Icons.home,
                      color: AppColors.kPrimaryColor,
                    )),
          IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.person,
                      color: AppColors.kBlackColor,
                    )
                  : const Icon(
                      Icons.person,
                      color: AppColors.kPrimaryColor,
                    )),
          IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.notifications,
                      color: AppColors.kBlackColor,
                    )
                  : const Icon(
                      Icons.notifications,
                      color: AppColors.kPrimaryColor,
                    )),
          IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: pageIndex == 3
                  ? const Icon(
                      Icons.settings,
                      color: AppColors.kBlackColor,
                    )
                  : const Icon(
                      Icons.settings,
                      color: AppColors.kPrimaryColor,
                    )),
        ],
      ),
    );
  }
}
