// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:committee_app/resources/colors.dart';
// import 'package:committee_app/resources/components/app_bar_widget.dart';
// import 'package:committee_app/resources/components/loading_widget.dart';
// import 'package:committee_app/resources/constants.dart';
// import 'package:committee_app/resources/text_constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class UserDashBoardView extends StatefulWidget {
//   const UserDashBoardView({super.key});
//
//   @override
//   State<UserDashBoardView> createState() => _UserDashBoardViewState();
// }
//
// class _UserDashBoardViewState extends State<UserDashBoardView> {
//   final FirebaseFirestore fireStore = FirebaseFirestore.instance;
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const AppBarWidget(title: "My Committees"),
//       backgroundColor: AppColors.kPrimaryColor,
//       body: StreamBuilder(
//           stream: fireStore
//               .collection(AppConstants.userDataCollectionName)
//               .doc(auth.currentUser!.uid)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Text(
//                 "Error ${snapshot.error}",
//                 style: textTheme.titleMedium!.copyWith(
//                   fontSize: 25.sp,
//                 ),
//               );
//             } else if (!snapshot.hasData || !snapshot.data!.exists) {
//               return const Center(
//                   child: LoadingWidget(
//                 color: AppColors.kSecondaryColor,
//               ));
//             } else {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       snapshot.data!.get('committee_joined_by_user').first,
//                       style: textTheme.titleMedium!.copyWith(
//                         fontSize: 25.sp,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30.h,
//                     ),
//                     Text(
//                       snapshot.data!.get('Email'),
//                       style: textTheme.titleMedium!.copyWith(
//                         fontSize: 20.sp,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//           }),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/app_bar_widget.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/components/no_data_available_widget.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class UserDashBoardView extends StatefulWidget {
  const UserDashBoardView({super.key});

  @override
  State<UserDashBoardView> createState() => _UserDashBoardViewState();
}

class _UserDashBoardViewState extends State<UserDashBoardView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future signOutUser() async {
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.loginScreen, (route) => false);
      } else {
        await auth.signOut();
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.loginScreen, (route) => false);
      }
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<List<DocumentSnapshot>> fetchCommitteeDetails(
      List<String> committeeIds) async {
    List<DocumentSnapshot> committeeDetails = [];

    for (String id in committeeIds) {
      DocumentSnapshot doc =
          await firestore.collection(AppConstants.adminCommittee).doc(id).get();
      if (doc.exists) {
        committeeDetails.add(doc);
      }
    }
    return committeeDetails;
  }

  String month = DateFormat('MMMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "My Committees"),
      backgroundColor: AppColors.kPrimaryColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore
            .collection(AppConstants.userDataCollectionName)
            .doc(auth.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: textTheme.titleMedium!.copyWith(
                  fontSize: 25.sp,
                ),
              ),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
                child: LoadingWidget(
              color: AppColors.kSecondaryColor,
            ));
          } else {
            List<String> committeeIds = List<String>.from(
                snapshot.data!.get('committee_joined_by_user'));
            print(committeeIds);
            return FutureBuilder<List<DocumentSnapshot>>(
              future: fetchCommitteeDetails(committeeIds),
              builder: (context, committeeSnapshot) {
                if (committeeSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: LoadingWidget(
                      color: AppColors.kSecondaryColor,
                    ),
                  );
                } else if (committeeSnapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${committeeSnapshot.error}",
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 25.sp,
                      ),
                    ),
                  );
                } else if (!committeeSnapshot.hasData ||
                    committeeSnapshot.data!.isEmpty) {
                  return Center(
                      child: NoDataAvailableWidget(
                    isButton: true,
                    title: "Join Committees",
                    width: 200.w,
                    height: 50.h,
                    onTap: () {
                      Navigator.pushNamed(
                          context, RouteNames.userCommitteeView);
                    },
                  ));
                } else {
                  return ListView.builder(
                    itemCount: committeeSnapshot.data!.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot committeeDoc =
                          committeeSnapshot.data![index];
                      List<dynamic> committeeMembers =
                          committeeDoc.get('members_list');
                      int memberCount = committeeMembers.length;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Container(
                            height: 0.35.sh,
                            width: 1.sw,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 20.h),
                            margin: EdgeInsets.only(bottom: 10.h, top: 5.h),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Committee Name : ${committeeDoc.get('committee_name')}",
                                  style: textTheme.titleMedium!.copyWith(
                                    fontSize: 20.sp,
                                  ),
                                ),
                                const Divider(
                                  color: AppColors.kSecondaryColor,
                                ),
                                Text(
                                  "No of Members : ${committeeDoc.get('number_of_members')}",
                                  style: textTheme.titleMedium,
                                ),
                                committeeDoc.get(
                                            'this_month_committee_member_selected') ==
                                        ""
                                    ? Text(
                                        "$month Committee : Member are not selected yet.",
                                        style: textTheme.titleMedium,
                                      )
                                    : Text(
                                        "$month Committee : ${committeeDoc.get('this_month_committee_member_selected')}",
                                        style: textTheme.titleMedium,
                                      ),
                                Text(
                                  "Committee Joined Members : $memberCount",
                                  style: textTheme.titleMedium,
                                ),
                                Text(
                                  "Total Amount : ${committeeDoc.get('total_amount')}",
                                  style: textTheme.titleMedium,
                                ),
                                Text(
                                  "Committee Start date : ${committeeDoc.get('committee_start_date')}",
                                ),
                                Text(
                                  "Committee End date : ${committeeDoc.get('committee_end_date')}",
                                  style: textTheme.titleMedium,
                                ),
                              ],
                            )),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
