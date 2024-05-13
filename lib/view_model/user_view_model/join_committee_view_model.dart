import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserJoinCommitteeViewModel extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String? userName, userUid;

  Future getCurrentUserData(adminUid) async {
    try {
      final DocumentSnapshot data = await fireStore
          .collection(AppConstants.userDataCollectionName)
          .doc(auth.currentUser!.uid)
          .get();
      if (data.exists) {
        userName = data['Name'];
        userUid = data['UserUid'];
        sendNotificationToAdmin(userName, adminUid);
      }
    } catch (e) {
      sendNotificationToAdmin("Someone", adminUid);
    }
  }

  Future sendNotificationToAdmin(name, adminUid) async {
    try {
      var url = Uri.parse(AppConstants.fcmUrl);
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=${AppConstants.apiKey}'
      };
      var body = {
        'to':
            'd7yS_JRsRI-mSaXiTx5nnz:APA91bGlhsC9c9WE3rYSPLSXEnXBLL439fGD6ugIAFXo2YMmpoP0YxYJ5mc5fPZEHKEpnQZw4jnWYdurGCxujz7kpaFNrRnE8ayK90Wryh1mkta1_3nS6lIRYE3c5mc-qSUb9FXU_QLd',
        'priority': 'high',
        'notification': {
          'title': "Committee joining request",
          'body': "$name want to join your committee",
        },
        'data': {
          'type': 'request',
          'user_id': auth.currentUser!.uid,
        }
      };
      final response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print(response.statusCode);
      if (response.statusCode == 200) {
        sendDataToAdminNotification(adminUid);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List notification = [];
  Future sendDataToAdminNotification(admin) async {
    await fireStore
        .collection(AppConstants.notification)
        .doc(admin)
        .set({'notification': notification});
  }
}
