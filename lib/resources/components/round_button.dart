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
  final double height;
  final double width;
  final Color buttonColor;
  const LoginSignUpButton(
      {super.key,
      required this.title,
      this.loading = false,
      required this.onPress,
      this.height = 50,
      this.width = 300,
      this.buttonColor = AppColors.kSecondaryColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      overlayColor: const MaterialStatePropertyAll(AppColors.kWhiteColor),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(10.r)),
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
