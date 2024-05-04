import 'dart:io';

import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/components/text_field.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:committee_app/view_model/user_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../resources/components/social_button.dart';
import '../../resources/components/text_button.dart';

class UserSignUpView extends StatefulWidget {
  const UserSignUpView({super.key});

  @override
  State<UserSignUpView> createState() => _UserSignUpViewState();
}

class _UserSignUpViewState extends State<UserSignUpView> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (BuildContext context) => SignUpViewModel(context),
      child: Consumer<SignUpViewModel>(
        builder: (BuildContext context, SignUpViewModel model, Widget? child) =>
            Scaffold(
          backgroundColor: AppColors.kPrimaryColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: model.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50.h,
                    ),
                    Text(
                      "USER SIGN UP",
                      style: textTheme.titleMedium!.copyWith(
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                        "Looks like you don't have an account. Let's create a new account for you",
                        style: textTheme.titleSmall),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          model.settingModalBottomSheet(context, () {
                            model
                                .pickImage(ImageSource.camera)
                                .then((value) => Navigator.pop(context));
                          }, () {
                            model
                                .pickImage(ImageSource.gallery)
                                .then((value) => Navigator.pop(context));
                          });
                        },
                        overlayColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                        child: Container(
                          height: 130.h,
                          width: 130.w,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.kBlackColor),
                              shape: BoxShape.circle),
                          child: CircleAvatar(
                            backgroundImage: model.userImage == ''
                                ? null
                                : FileImage(
                                    File(model.userImage),
                                  ),
                            backgroundColor: Colors.transparent,
                            child: model.userImage == ''
                                ? Lottie.asset(
                                    "assets/lottie/user_profile_image.json")
                                : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFieldWidget(
                      width: width,
                      node: model.userNameNode,
                      title: "Name",
                      controller: model.userNameController,
                      textInputType: TextInputType.emailAddress,
                      function: () {
                        Utils.focusNodeChange(
                            context, model.userNameNode, model.emailNode);
                      },
                      onTapFunction: () {},
                      icon: Icons.person_2_outlined,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFieldWidget(
                      width: width,
                      node: model.emailNode,
                      title: "Email",
                      controller: model.emailController,
                      textInputType: TextInputType.emailAddress,
                      function: () {
                        Utils.focusNodeChange(
                            context, model.emailNode, model.userPhoneNode);
                      },
                      onTapFunction: () {},
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFieldWidget(
                      width: width,
                      node: model.userPhoneNode,
                      title: "Phone Number",
                      controller: model.userPhoneNumberController,
                      textInputType: TextInputType.phone,
                      function: () {
                        Utils.focusNodeChange(context, model.userPhoneNode,
                            model.userAddressNode);
                      },
                      onTapFunction: () {},
                      icon: Icons.phone,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFieldWidget(
                      width: width,
                      node: model.userAddressNode,
                      title: "Address",
                      controller: model.userAddressController,
                      textInputType: TextInputType.text,
                      function: () {
                        Utils.focusNodeChange(
                            context, model.userAddressNode, model.passwordNode);
                      },
                      onTapFunction: () {},
                      icon: Icons.home,
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
                      height: 50.h,
                    ),
                    LoginSignUpButton(
                      title: "CREATE ACCOUNT",
                      onPress: () {
                        if (model.userNameController.text.isEmpty ||
                            model.emailController.text.isEmpty ||
                            model.passwordController.text.isEmpty) {
                          Utils.errorMessage(
                              context, "All fields are required");
                        } else {
                          if (model.formKey.currentState!.validate()) {
                            model.registerUser();
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
                    LoginSignUpButton(
                        title: "CREATE ADMIN ACCOUNT",
                        onPress: () {
                          print("Asdsada");
                          Navigator.pushReplacementNamed(
                              context, RouteNames.adminSignUpScreen);
                        }),
                    // SocialButtonWidget(
                    //     title: "Continue with Google",
                    //     loading: model.isGoogleLoading,
                    //     onPress: () {
                    //       model.googleSignIn();
                    //     },
                    //     image: "assets/images/google2.png"),
                    SizedBox(
                      height: 40.h,
                    ),
                    TextButtonWidget(
                      title: "Already have an account?",
                      onPress: () {
                        // Navigator.pushNamed(context, RouteNames.loginScreen);
                        Navigator.pop(context);
                      },
                      textThemeStyle: textTheme.titleSmall!
                          .copyWith(color: AppColors.kSecondaryColor),
                      onPressTitle: 'Sign In',
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
