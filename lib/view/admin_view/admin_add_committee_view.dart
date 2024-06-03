import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/round_button.dart';
import 'package:committee_app/resources/components/text_field.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:committee_app/view_model/admin_view_model/admin_add_committee_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AdminAddCommitteeView extends StatefulWidget {
  const AdminAddCommitteeView({super.key});

  @override
  State<AdminAddCommitteeView> createState() => _AdminAddCommitteeViewState();
}

class _AdminAddCommitteeViewState extends State<AdminAddCommitteeView> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (BuildContext context) => AdminAddCommitteeViewModel(context),
      child: Consumer<AdminAddCommitteeViewModel>(
        builder: (BuildContext context, AdminAddCommitteeViewModel model,
                Widget? child) =>
            Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.kPrimaryColor,
            scrolledUnderElevation: 0,
            title: Text(
              "Create a committee",
              style: textTheme.titleMedium!.copyWith(
                fontSize: 20.sp,
              ),
            ),
            centerTitle: true,
          ),
          backgroundColor: AppColors.kPrimaryColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                      "It's a way for individuals to save money collectively and access funds when needed without relying on traditional banking systems.",
                      style: textTheme.titleSmall),
                  SizedBox(
                    height: 40.h,
                  ),
                  TextFieldWidget(
                    width: width,
                    node: model.committeeNameNode,
                    title: "Committee Name",
                    controller: model.committeeNameController,
                    textInputType: TextInputType.emailAddress,
                    function: () {
                      Utils.focusNodeChange(context, model.committeeNameNode,
                          model.committeeMemberNode);
                    },
                    onTapFunction: () {},
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFieldWidget(
                    width: width,
                    node: model.committeeMemberNode,
                    title: "Number of Members",
                    controller: model.committeeMemberController,
                    textInputType: TextInputType.phone,
                    function: () {
                      Utils.focusNodeChange(context, model.committeeMemberNode,
                          model.committeeAmountNode);
                    },
                    onTapFunction: () {},
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFieldWidget(
                    width: width,
                    node: model.committeeAmountNode,
                    title: "Total Amount",
                    controller: model.committeeAmountController,
                    textInputType: TextInputType.phone,
                    function: () {},
                    onTapFunction: () {},
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  InkWell(
                    onTap: () {
                      model.selectStartDate();
                    },
                    child: Container(
                      height: 60.h,
                      width: width,
                      decoration: BoxDecoration(
                        color: AppColors.kWhiteColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.startDate == null
                              ? "Select Start Date"
                              : "${model.startDate!.day}/${model.startDate!.month}/${model.startDate!.year}",
                          style: textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.w100),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  InkWell(
                    onTap: () {
                      model.selectEndDate();
                    },
                    child: Container(
                      height: 60.h,
                      width: width,
                      decoration: BoxDecoration(
                        color: AppColors.kWhiteColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.endDate == null
                              ? "Select End Date"
                              : "${model.endDate!.day}/${model.endDate!.month}/${model.endDate!.year}",
                          style: textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.w100),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  LoginSignUpButton(
                    title: "Create committee",
                    onPress: () {
                      if (model.committeeNameController.text.isEmpty ||
                          model.committeeMemberController.text.isEmpty ||
                          model.committeeAmountController.text.isEmpty ||
                          model.startDate == null ||
                          model.endDate == null) {
                        Utils.errorMessage(context, "All fields are required");
                      } else {
                        model.committeeDataToFireStore();
                      }
                    },
                    height: 60.h,
                    width: 1.sw,
                    loading: model.isLoading,
                  ),
                  SizedBox(
                    height: 40.h,
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
