import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminAddCommitteeViewModel extends ChangeNotifier {
  AdminAddCommitteeViewModel(this.context);
  BuildContext context;
  TextEditingController committeeNameController = TextEditingController();
  TextEditingController committeeAmountController = TextEditingController();
  TextEditingController committeeMemberController = TextEditingController();
  FocusNode committeeNameNode = FocusNode();
  FocusNode committeeAmountNode = FocusNode();
  FocusNode committeeMemberNode = FocusNode();
  DateTime? startDate, endDate;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List members=[];
  bool isLoading = false;

  Future committeeDataToFireStore() async {
    isLoading = true;
    notifyListeners();
    await fireStore
        .collection(AppConstants.adminCommittee)
        .doc(committeeNameController.text)
        .set({
          "committee_name": committeeNameController.text.toString(),
          "number_of_members": committeeMemberController.text,
          "total_amount": committeeAmountController.text,
          "committee_start_date":
              "${startDate!.day}/${startDate!.month}/${startDate!.year}",
          "committee_end_date":
              "${endDate!.day}/${endDate!.month}/${endDate!.year}",
          "created_at": DateTime.now(),
          "members_list": members
        })
        .then((value) => {
              Utils.successMessage(context, "Committee created successfully"),
              isLoading = false,
              notifyListeners(),
      Navigator.pop(context),
            })
        .onError((error, stackTrace) => {
              Utils.errorMessage(context, error.toString()),
              isLoading = false,
              notifyListeners(),
            });
  }

  Future<void> selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.kPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      startDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.kPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      endDate = picked;
      notifyListeners();
    }
  }
}