import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/colors.dart';
import 'package:committee_app/resources/components/loading_widget.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminRequestView extends StatefulWidget {
  const AdminRequestView({super.key});

  @override
  State<AdminRequestView> createState() => _AdminRequestViewState();
}

class _AdminRequestViewState extends State<AdminRequestView> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: StreamBuilder(
          stream: fireStore
              .collection(AppConstants.committeeRequests)
              .doc(auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget(
                color: AppColors.kSecondaryColor,
              );
            } else if (snapshot.hasError) {
              return Text(
                "Error ${snapshot.error}",
                style: textTheme.titleMedium,
              );
            } else {
              return Container(
                height: 100,
                color: Colors.red,
                child: Text(snapshot.data!.id),
              );
            }
          }),
    );
  }
}
