import 'dart:io';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/components/text_field.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:committee_app/view_model/admin_view_model/admin_signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../resources/components/text_button.dart';

class AdminSignUpView extends StatefulWidget {
  const AdminSignUpView({super.key});

  @override
  State<AdminSignUpView> createState() => _AdminSignUpViewState();
}

class _AdminSignUpViewState extends State<AdminSignUpView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AdminSignUpViewModel(context),
      child: Consumer<AdminSignUpViewModel>(
        builder:
            (BuildContext context, AdminSignUpViewModel model, Widget? child) =>
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
                      "ADMIN SIGN UP",
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
                            backgroundImage: model.adminImage == ''
                                ? null
                                : FileImage(
                                    File(model.adminImage),
                                  ),
                            backgroundColor: Colors.transparent,
                            child: model.adminImage == ''
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
                      width: 1.sw,
                      node: model.adminNameNode,
                      title: "Name",
                      controller: model.adminNameController,
                      textInputType: TextInputType.emailAddress,
                      function: () {
                        Utils.focusNodeChange(
                            context, model.adminNameNode, model.adminEmailNode);
                      },
                      onTapFunction: () {},
                      icon: Icons.person_2_outlined,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFieldWidget(
                      width: 1.sw,
                      node: model.adminEmailNode,
                      title: "Email",
                      controller: model.adminEmailController,
                      textInputType: TextInputType.emailAddress,
                      function: () {
                        Utils.focusNodeChange(
                            context, model.adminEmailNode, model.adminPhoneNode);
                      },
                      onTapFunction: () {},
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFieldWidget(
                      width: 1.sw,
                      node: model.adminPhoneNode,
                      title: "Phone Number",
                      controller: model.adminPhoneNumberController,
                      textInputType: TextInputType.phone,
                      function: () {
                        Utils.focusNodeChange(context, model.adminPhoneNode,
                            model.adminAddressNode);
                      },
                      onTapFunction: () {},
                      icon: Icons.phone,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    TextFieldWidget(
                      width: 1.sw,
                      node: model.adminAddressNode,
                      title: "Address",
                      controller: model.adminAddressController,
                      textInputType: TextInputType.text,
                      function: () {
                        Utils.focusNodeChange(
                            context, model.adminAddressNode, model.adminPasswordNode);
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
                          width: 1.sw,
                          node: model.adminPasswordNode,
                          controller: model.adminPasswordController,
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
                        if (model.adminNameController.text.isEmpty ||
                            model.adminEmailController.text.isEmpty ||
                            model.adminPasswordController.text.isEmpty) {
                          Utils.errorMessage(
                              context, "All fields are required");
                        } else {
                          if (model.formKey.currentState!.validate()) {
                            model.registerAdmin();
                          }
                        }
                      },
                      width: 1.sw,
                      height: 60.h,
                      loading: model.isLoading,
                    ),
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
