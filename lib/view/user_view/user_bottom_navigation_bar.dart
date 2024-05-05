import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/view/user_view/user_account_view.dart';
import 'package:committee_app/view/user_view/user_dashboard_view.dart';
import 'package:committee_app/view/user_view/user_joined_committe_view.dart';
import 'package:committee_app/view/user_view/user_notification_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserBottomNavigationBar extends StatefulWidget {
  const UserBottomNavigationBar({super.key});

  @override
  State<UserBottomNavigationBar> createState() =>
      _UserBottomNavigationBarState();
}

class _UserBottomNavigationBarState extends State<UserBottomNavigationBar> {
  int pageIndex = 0;

  final pages = [
    const UserDashBoardView(),
    const UserJoinedCommitteeView(),
    const UserNotificationView(),
    const UserSettingsView()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 55.h),
        height: 76.h,
        width: 70.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          color: AppColors.kPrimaryColor,
          // image: const DecorationImage(fit: BoxFit.,
          //     image: AssetImage(AppImagesUrl.homeBackGround))
        ),
        child: InkWell(
          onTap: () {
            print("object");
          },
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: 70.h,
                  width: 65.w,
                  decoration: BoxDecoration(
                      color: AppColors.kSecondaryColor,
                      borderRadius: BorderRadius.circular(100.r)),
                ),
              ),
              const Center(
                child: Icon(
                  Icons.add,
                  color: AppColors.kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
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
