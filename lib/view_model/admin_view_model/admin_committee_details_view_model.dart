import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AdminCommitteeDetailsViewModel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  bool isLoading = false;

  Future uploadDataToCommitteePaidByUser(userUid, deviceToken, userName) async {
    try {
      isLoading = true;
      notifyListeners();
      await fireStore
          .collection(AppConstants.adminCommittee)
          .doc(auth.currentUser!.uid)
          .update({
        'committee_paid_by_members': FieldValue.arrayUnion([userUid])
      }).then((value) =>
              {monthlyCommitteePaidByUser(userUid, deviceToken, userName)});
      isLoading = true;
      notifyListeners();
    } catch (e) {
      isLoading = true;
      notifyListeners();
      print(e.toString());
    }
  }

  Future monthlyCommitteePaidByUser(userId, deviceToken, userName) async {
    if (deviceToken == " ") {

    } else {
      DateTime now = DateTime.now();
      String monthName = DateFormat('MMMM').format(now);
      try {
        var url = Uri.parse(AppConstants.fcmUrl);
        var headers = {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=${AppConstants.apiKey}'
        };
        var body = {
          'to': deviceToken,
          'priority': 'high',
          'notification': {
            'title': "Monthly Committee Paid",
            'body': "$userName you pay committee of month $monthName",
          },
          'data': {
            'type': 'request',
            'user_id': auth.currentUser!.uid,
          }
        };
        final response =
            await http.post(url, body: jsonEncode(body), headers: headers);
        if (response.statusCode == 200) {
        } else {}
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }
}
