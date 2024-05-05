import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/components/social_button.dart';
import 'package:committee_app/resources/components/text_field.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:committee_app/view_model/forgot_password_view_model.dart';
import 'package:committee_app/view_model/login_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../resources/components/text_button.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (BuildContext context) => ForgotPasswordViewModel(context),
      child: Consumer<ForgotPasswordViewModel>(
        builder: (BuildContext context, ForgotPasswordViewModel model,
                Widget? child) =>
            Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.kPrimaryColor,
          ),
          backgroundColor: AppColors.kPrimaryColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Center(
                    child: SizedBox(
                      height: 250.h,
                      width: 250.w,
                      child: Lottie.asset("assets/lottie/forgot_password.json"),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "FORGOT PASSWORD",
                    style: textTheme.titleMedium!.copyWith(
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text("Please enter your email", style: textTheme.titleSmall),
                  SizedBox(
                    height: 40.h,
                  ),
                  TextFieldWidget(
                    width: width,
                    node: model.emailNode,
                    title: "Email",
                    controller: model.emailController,
                    textInputType: TextInputType.emailAddress,
                    onTapFunction: () {},
                    icon: Icons.email_outlined,
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  LoginSignUpButton(
                    title: "Forgot Password",
                    onPress: () {
                      model.resetPassword(model.emailController.text);
                    },
                    loading: model.isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
