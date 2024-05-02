import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/components/social_button.dart';
import 'package:committee_app/resources/components/text_field.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:committee_app/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../resources/components/text_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (BuildContext context) => LoginViewModel(context),
      child: Consumer<LoginViewModel>(
        builder: (BuildContext context, LoginViewModel model, Widget? child) =>
            Scaffold(
          backgroundColor: AppColors.kWhiteColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: model.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50.h,
                    ),
                    Text(
                      "REUNION",
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 25.sp,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "SIGN IN",
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text("Please enter your credentials to continue",
                        style: textTheme.titleSmall),
                    SizedBox(
                      height: 40.h,
                    ),
                    TextFieldWidget(
                      width: width,
                      node: model.emailNode,
                      title: "Email",
                      controller: model.emailController,
                      textInputType: TextInputType.emailAddress,
                      function: () {
                        Utils.focusNodeChange(
                            context, model.emailNode, model.passwordNode);
                      },
                      onTapFunction: () {},
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ValueListenableBuilder(
                      valueListenable: model.obscureText,
                      builder: (context, value, child) {
                        return TextFieldWidget(
                          width: width,
                          node: model.passwordNode,
                          controller: model.passwordController,
                          title: 'Password',
                          textInputType: TextInputType.text,
                          function: () {},
                          obscureText: model.obscureText.value,
                          onTapFunction: () {
                            model.obscureText.value = !model.obscureText.value;
                          },
                          icon: model.obscureText.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        );
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButtonWidget(
                        onPress: () {},
                        textThemeStyle: textTheme.bodyMedium!,
                        onPressTitle: 'Forgot Password?',
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    LoginSignUpButton(
                      title: "LOGIN",
                      onPress: () {
                        if (model.emailController.text.isEmpty ||
                            model.passwordController.text.isEmpty) {
                          Utils.errorMessage(
                              context, "All fields are required");
                        } else {
                          if (model.formKey.currentState!.validate()) {
                            model.signIn();
                          }
                        }
                      },
                      loading: model.isLoading,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        SizedBox(
                          width: 10.w,
                        ),
                        const Text("OR"),
                        SizedBox(
                          width: 10.w,
                        ),
                        const Expanded(child: Divider())
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SocialButtonWidget(
                        title: "Sign Up with Google",
                        loading: model.isGoogleLoading,
                        onPress: () {
                          model.googleSignIn();
                        },
                        image: "assets/images/google2.png"),
                    SizedBox(
                      height: 120.h,
                    ),
                    TextButtonWidget(
                      title: "Don’t have an account?",
                      onPress: () {
                        Navigator.pushNamed(context, RouteNames.signUpScreen);
                      },
                      textThemeStyle: textTheme.titleSmall!
                          .copyWith(color: AppColors.kPrimaryColor),
                      onPressTitle: 'Signup',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
