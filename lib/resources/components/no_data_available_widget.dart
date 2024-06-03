import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/images_url.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class NoDataAvailableWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isButton;
  final String title;
  final double height, width;
  const NoDataAvailableWidget(
      {super.key,
      this.onTap,
      this.isButton = false,
      this.title = "Reload",
      this.height = 50,
      this.width = 150});

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
          isButton
              ? InkWell(
                  overlayColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  onTap: onTap,
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: AppColors.kSecondaryColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColors.kSecondaryColor.withOpacity(0.5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        title,
                        style: textTheme.bodyLarge!
                            .copyWith(color: AppColors.kWhiteColor),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
