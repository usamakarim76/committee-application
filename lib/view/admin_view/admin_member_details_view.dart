import 'package:committee_app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminMemberDetailsView extends StatefulWidget {
  const AdminMemberDetailsView({super.key});

  @override
  State<AdminMemberDetailsView> createState() => _AdminMemberDetailsViewState();
}

class _AdminMemberDetailsViewState extends State<AdminMemberDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: Container(
        height: 1.sh,
        width: 1.sw,
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
