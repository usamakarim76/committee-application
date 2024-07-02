import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/app_bar_widget.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminMemberDetailsView extends StatefulWidget {
  final String userUid;
  const AdminMemberDetailsView({super.key, required this.userUid});

  @override
  State<AdminMemberDetailsView> createState() => _AdminMemberDetailsViewState();
}

class _AdminMemberDetailsViewState extends State<AdminMemberDetailsView> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    print(widget.userUid);
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: const AppBarWidget(
        title: "User Details",
        check: true,
      ),
      body: Container(
          height: 1.sh,
          width: 1.sw,
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: StreamBuilder(
              stream: fireStore
                  .collection(AppConstants.userDataCollectionName)
                  .doc(widget.userUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const LoadingWidget(
                    color: AppColors.kSecondaryColor,
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: textTheme.titleMedium,
                    ),
                  );
                } else {
                  var userData = snapshot.data!.data();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundImage: userData!['ProfileImage'] == ""
                              ? null
                              : NetworkImage(
                                  userData['ProfileImage'],
                                ),
                          radius: 90.r,
                          child: userData['ProfileImage'] == ""
                              ? Text(
                                  "No image",
                                  style: textTheme.titleMedium!
                                      .copyWith(fontSize: 10.sp),
                                )
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        userData['Name'],
                        style: textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        userData['PhoneNumber'],
                        style: textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        userData['Email'],
                        style: textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        userData['Address'],
                        style: textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: 150.h,
                      ),
                      LoginSignUpButton(
                        title: "Committee paid",
                        onPress: () {},
                        height: 60.h,
                        width: 1.sw,
                      ),
                    ],
                  );
                }
              })),
    );
  }
}
