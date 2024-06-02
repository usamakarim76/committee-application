import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/images_url.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class NoDataAvailableWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isButton;
  const NoDataAvailableWidget({super.key, this.onTap, this.isButton= false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 300.h,
            width: 300.w,
            child: Lottie.asset(
              AppAssetsUrl.noDataAvailable,
            ),
          ),
          isButton ? InkWell(
            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
            onTap: onTap,
            child: Container(
              width: 150.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.kSecondaryColor,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.kSecondaryColor.withOpacity(0.5),
                ),
              ),
              child: Center(
                child: Text(
                  "Reload",
                  style: textTheme.bodyLarge!
                      .copyWith(color: AppColors.kWhiteColor),
                ),
              ),
            ),
          ): const SizedBox(),
        ],
      ),
    );
  }
}
