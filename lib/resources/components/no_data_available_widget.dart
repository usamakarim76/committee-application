import 'package:committee_app/resources/images_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class NoDataAvailableWidget extends StatelessWidget {
  const NoDataAvailableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          height: 300.h,
          width: 300.w,
          child: Lottie.asset(AppAssetsUrl.noDataAvailable)),
    );
  }
}
