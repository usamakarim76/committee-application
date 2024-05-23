import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/app_bar_widget.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Terms & Conditions",check: true,),
      backgroundColor: AppColors.kPrimaryColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingText("Eligibility"),
              paragraphText(
                  '''To be eligible to use our services, you must:\n* Be at least 18 years old.\n* Provide accurate and complete registration information.\n* Agree to these Terms and Conditions.'''),
              SizedBox(
                height: 20.h,
              ),
              headingText("Formation of Committees"),
              paragraphText(
                  ''''* Committees are formed based on mutual agreement among members.\n* Each committee will have a specified contribution amount and duration.\n* All members must agree to the terms of the committee before joining.'''),
              SizedBox(
                height: 20.h,
              ),
              headingText("Contributions"),
              paragraphText(
                  "* Members must contribute the agreed amount each month by the specified date.\n* Failure to contribute on time may result in penalties or removal from the committee."),
              SizedBox(
                height: 20.h,
              ),
              headingText("Payouts"),
              paragraphText(
                  "* Payouts will be made to members based on the agreed schedule.\n* The platform will facilitate the collection and distribution of funds."),
              SizedBox(
                height: 20.h,
              ),
              headingText("Member Responsibilities"),
              paragraphText(
                  "* Members must ensure timely contributions.\n* Members must not engage in fraudulent activities.\n* Members must keep their account information up-to-date."),
              SizedBox(
                height: 20.h,
              ),
              headingText("Platform Responsibilities"),
              paragraphText(
                  "* The platform will provide a secure and reliable service for managing committees.\n* The platform will handle the collection and distribution of funds. \n* The platform will offer support for resolving disputes among members."),
              SizedBox(
                height: 20.h,
              ),
              headingText("Termination"),
              paragraphText(
                  "* Members may terminate their participation in a committee by providing notice as specified in the committee agreement.\n* The platform reserves the right to terminate a member's account for violating these terms."),
              SizedBox(
                height: 20.h,
              ),
              headingText("Dispute Resolution"),
              paragraphText(
                  "* Any disputes between members should first be attempted to be resolved amicably.\n* The platform will provide mediation services for unresolved disputes.\n* Legal action should be a last resort after exhausting all other avenues."),
              SizedBox(
                height: 20.h,
              ),
              headingText("Privacy and Data Protection"),
              paragraphText(
                  "* The platform will handle personal data in accordance with our Privacy Policy.\n* Members consent to the use of their data for the purposes of managing the committee."),
              SizedBox(
                height: 20.h,
              ),
              headingText("Liability"),
              paragraphText(
                  "* The platform is not liable for any losses or damages arising from participation in a committee.\n* Members participate at their own risk."),
              SizedBox(
                height: 20.h,
              ),
              headingText("Amendments"),
              paragraphText(
                  "* The platform reserves the right to amend these terms at any time.\n* Members will be notified of any changes to the terms and conditions."),
              SizedBox(
                height: 20.h,
              ),
              headingText("Governing Law"),
              paragraphText(
                  "* These terms are governed by the laws of Pakistan."),
              SizedBox(
                height: 50.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headingText(title) {
    return Text(
      title,
      style: textTheme.titleLarge!.copyWith(fontSize: 18.sp),
      textAlign: TextAlign.justify,
    );
  }

  Widget paragraphText(title) {
    return Text(
      title,
      style: textTheme.titleSmall,
      textAlign: TextAlign.justify,
    );
  }
}
