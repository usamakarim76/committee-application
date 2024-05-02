import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButtonWidget extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onPress;
  final String image;
  const SocialButtonWidget(
      {super.key,
      required this.title,
      required this.loading,
      required this.onPress,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      overlayColor: const MaterialStatePropertyAll(AppColors.kWhiteColor),
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        decoration: BoxDecoration(
            color: AppColors.kGrayColor,
            borderRadius: BorderRadius.circular(30.r)),
        child: loading
            ? Center(
                child: loadingWidget(AppColors.kPrimaryColor),
              )
            : Row(
                children: [
                  Image.asset(
                    image,
                    width: 30.w,
                    height: 30.h,
                  ),
                  SizedBox(
                    width: 65.w,
                  ),
                  Text(
                    title,
                    style: textTheme.titleSmall!
                        .copyWith(color: AppColors.kBlackColor),
                  ),
                ],
              ),
      ),
    );
  }
}
