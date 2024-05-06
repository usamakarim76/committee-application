import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {super.key,
      required this.width,
      required this.controller,
      required this.node,
      required this.title,
      this.function,
      required this.textInputType,
      this.obscureText = false,
      required this.onTapFunction,
      this.icon});

  final double width;
  final TextEditingController controller;
  final FocusNode node;
  final String title;
  final Function? function;
  final TextInputType textInputType;
  final bool obscureText;
  final VoidCallback onTapFunction;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: width,
      decoration: BoxDecoration(
          color: AppColors.kWhiteColor,
          borderRadius: BorderRadius.circular(10.r)),
      child: TextFormField(
        controller: controller,
        keyboardType: textInputType,
        focusNode: node,
        style: textTheme.titleSmall,
        obscureText: obscureText,
        cursorColor: AppColors.kPrimaryColor,
        decoration: InputDecoration(
            hintText: title,
            alignLabelWithHint: true,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(vertical: 18.h, horizontal: 25.w),
            isDense: true,
            suffixIcon: InkWell(
              overlayColor:
                  const MaterialStatePropertyAll(AppColors.kWhiteColor),
              onTap: onTapFunction,
              child: Icon(
                icon,
                color: AppColors.kSecondaryColor,
                size: 25,
              ),
            ),
            hintStyle:
                textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w100)),
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        onFieldSubmitted: (value) {
          function!();
        },
        textCapitalization: title == "Name"
            ? TextCapitalization.words
            : TextCapitalization.none,
      ),
    );
  }
}
