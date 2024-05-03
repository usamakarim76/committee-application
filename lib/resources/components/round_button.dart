import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginSignUpButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onPress;
  const LoginSignUpButton(
      {super.key,
      required this.title,
      this.loading = false,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      overlayColor: const MaterialStatePropertyAll(AppColors.kWhiteColor),
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
            color: AppColors.kSecondaryColor,
            borderRadius: BorderRadius.circular(10.r)),
        child: Center(
          child: loading
              ? const LoadingWidget(
                  color: AppColors.kWhiteColor,
                )
              : Text(
                  title,
                  style: textTheme.titleMedium!
                      .copyWith(color: AppColors.kWhiteColor),
                ),
        ),
      ),
    );
  }
}
