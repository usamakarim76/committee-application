import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/components/text_field.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:committee_app/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
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
          backgroundColor: AppColors.kPrimaryColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: model.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70.h,
                    ),
                    Center(
                      child: SizedBox(
                        height: 220.h,
                        width: 200.w,
                        child:
                            Lottie.asset("assets/lottie/signInAnimation.json"),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
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
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        );
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RouteNames.forgotPasswordScreen);
                        },
                        style: const ButtonStyle(
                            overlayColor:
                                MaterialStatePropertyAll(Colors.transparent)),
                        child: Text(
                          "Forgot Password?",
                          style: textTheme.bodyMedium,
                        ),
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
                      width: 1.sw,
                      height: 60.h,
                      loading: model.isLoading,
                    ),
                    // SizedBox(
                    //   height: 30.h,
                    // ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: Divider(
                    //       color: AppColors.kBlackColor.withOpacity(0.2),
                    //     )),
                    //     SizedBox(
                    //       width: 10.w,
                    //     ),
                    //     const Text("OR"),
                    //     SizedBox(
                    //       width: 10.w,
                    //     ),
                    //     Expanded(
                    //         child: Divider(
                    //       color: AppColors.kBlackColor.withOpacity(0.2),
                    //     ))
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 30.h,
                    // ),
                    // SocialButtonWidget(
                    //     title: "Sign Up with Google",
                    //     loading: model.isGoogleLoading,
                    //     onPress: () {
                    //       model.googleSignIn();
                    //     },
                    //     image: "assets/images/google2.png"),
                    SizedBox(
                      height: 50.h,
                    ),
                    TextButtonWidget(
                      title: "Don’t have an account?",
                      onPress: () {
                        Navigator.pushNamed(
                            context, RouteNames.userSignUpScreen);
                      },
                      textThemeStyle: textTheme.titleSmall!
                          .copyWith(color: AppColors.kSecondaryColor),
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
