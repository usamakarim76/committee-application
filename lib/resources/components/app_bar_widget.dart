import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/images_url.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onPress;
  const AppBarWidget({
    super.key,
    required this.title,
    required this.onPress ,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.kPrimaryColor,
      title: Text(
        title,
        style: textTheme.titleMedium!
            .copyWith(color: AppColors.kWhiteColor, fontSize: 18.sp),
      ),
      iconTheme: const IconThemeData(color: AppColors.kSelectColor, size: 30),
      scrolledUnderElevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: onPress,
          icon: const Icon(
            Icons.add,
            size: 30,
            color: AppColors.kSelectColor,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        SizedBox(
          height: 35.h,
          width: 35.w,
          child: Image.asset(AppImagesUrl.homePersonLogo),
        ),
        SizedBox(
          width: 15.w,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
