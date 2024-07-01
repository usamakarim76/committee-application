import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/app_bar_widget.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/components/no_data_available_widget.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/images_url.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/view_model/admin_view_model/admin_request_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AdminRequestView extends StatefulWidget {
  const AdminRequestView({super.key});

  @override
  State<AdminRequestView> createState() => _AdminRequestViewState();
}

class _AdminRequestViewState extends State<AdminRequestView> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (BuildContext context) => AdminRequestViewModel(context),
        child: Consumer<AdminRequestViewModel>(
          builder: (BuildContext context, model, Widget? child) => Scaffold(
            appBar: const AppBarWidget(title: "User Requests"),
            backgroundColor: AppColors.kPrimaryColor,
            body: FutureBuilder(
                future: model.getRequestsForUser(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: LoadingWidget(
                        color: AppColors.kSecondaryColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      "Error ${snapshot.error}",
                      style: textTheme.titleMedium,
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return NoDataAvailableWidget(
                      isButton: true,
                      onTap: () {
                        model.updateData();
                      },
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        height: 1.sh,
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return Container(
                              height: 150.h,
                              width: 1.sw,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 20.h),
                              decoration: BoxDecoration(
                                color: AppColors.kWhiteColor,
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 2,
                                    spreadRadius: 0,
                                    offset: const Offset(4, 1),
                                    color:
                                        AppColors.kBlackColor.withOpacity(0.3),
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${snapshot.data![index].name} send you committee joining request",
                                    style: textTheme.titleMedium!
                                        .copyWith(fontSize: 15.sp),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      LoginSignUpButton(
                                        title: "Accept",
                                        onPress: () {
                                          model.acceptRequest(
                                              snapshot.data![index].userUid);
                                        },
                                        height: 45.h,
                                        width: 0.3.sw,
                                        buttonColor: const Color(0xff58B14C),
                                      ),
                                      LoginSignUpButton(
                                        title: "Reject",
                                        onPress: () {
                                          model.rejectRequest(
                                              snapshot.data![index].userUid);
                                          print("object");
                                        },
                                        height: 45.h,
                                        width: 0.3.sw,
                                        buttonColor: const Color(0xffE04142),
                                        loading: model.isLoading,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 20.h,
                            );
                          },
                        ),
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }
}
