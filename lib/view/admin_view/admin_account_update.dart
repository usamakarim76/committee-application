import 'dart:io';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/app_bar_widget.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/components/text_field.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:committee_app/view_model/admin_view_model/admin_account_update_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AdminAccountUpdateView extends StatefulWidget {
  const AdminAccountUpdateView({super.key});

  @override
  State<AdminAccountUpdateView> createState() => _AdminAccountUpdateViewState();
}

class _AdminAccountUpdateViewState extends State<AdminAccountUpdateView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AdminAccountUpdateViewModel(context),
      child: Consumer<AdminAccountUpdateViewModel>(
        builder: (BuildContext context, AdminAccountUpdateViewModel model,
                Widget? child) =>
            Scaffold(
                appBar: const AppBarWidget(
                  title: "Update Account",
                  check: true,
                ),
                backgroundColor: AppColors.kPrimaryColor,
                body: model.dataLoad
                    ? const Center(
                        child: LoadingWidget(
                          color: AppColors.kSecondaryColor,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 100.h,
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    model.settingModalBottomSheet(context, () {
                                      model.pickImage(ImageSource.camera).then(
                                          (value) => Navigator.pop(context));
                                    }, () {
                                      model.pickImage(ImageSource.gallery).then(
                                          (value) => Navigator.pop(context));
                                    });
                                  },
                                  overlayColor: const MaterialStatePropertyAll(
                                      Colors.transparent),
                                  child: Container(
                                    height: 160.h,
                                    width: 160.w,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.kBlackColor),
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
                                height: 60.h,
                              ),
                              TextFieldWidget(
                                width: 1.sw,
                                node: model.adminNameNode,
                                title: "Name",
                                controller: model.adminNameController,
                                textInputType: TextInputType.emailAddress,
                                function: () {
                                  Utils.focusNodeChange(
                                      context,
                                      model.adminNameNode,
                                      model.adminPhoneNode);
                                },
                                onTapFunction: () {},
                                icon: Icons.person_2_outlined,
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
                                  Utils.focusNodeChange(
                                      context,
                                      model.adminPhoneNode,
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
                                onTapFunction: () {},
                                icon: Icons.home,
                              ),
                              SizedBox(
                                height: 50.h,
                              ),
                              LoginSignUpButton(
                                title: "UPDATE ACCOUNT",
                                onPress: () {
                                  if (model.adminNameController.text.isEmpty ||
                                      model.adminPhoneNumberController.text
                                          .isEmpty ||
                                      model.adminAddressController.text
                                          .isEmpty) {
                                    Utils.errorMessage(
                                        context, "All fields are required");
                                  } else {
                                    model.updateAdminAccount();
                                  }
                                },
                                width: 1.sw,
                                height: 60.h,
                                loading: model.isLoading,
                              ),
                            ],
                          ),
                        ),
                      )),
      ),
    );
  }
}
