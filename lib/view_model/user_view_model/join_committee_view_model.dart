import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserJoinCommitteeViewModel extends ChangeNotifier {
  UserJoinCommitteeViewModel(this.context);
  BuildContext context;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String? userName, userUid;
  bool isLoading = false;

  Future getCurrentUserData(adminUid) async {
    try {
      Utils.showLoading();
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
    var checkUser = await fireStore
        .collection(AppConstants.committeeRequests)
        .doc(adminUid)
        .get();
    if (checkUser.exists) {
      List<dynamic> requests = checkUser.data()!['requests'];
      if (kDebugMode) {
        print(requests.contains(auth.currentUser!.uid));
      }
      if (requests.contains(auth.currentUser!.uid)) {
        Utils.removeLoading();
        Utils.errorMessage(context, "Request already send");
      } else {
        var data = await fireStore
            .collection(AppConstants.userDataCollectionName)
            .doc(adminUid)
            .get();
        if (data['DeviceToken'] == " ") {
          Utils.removeLoading();
          sendDataToAdminNotification(adminUid, name);
          sendDataToAdminRequests(adminUid);
        } else {
          var deviceToken = data['DeviceToken'];
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
            if (response.statusCode == 200) {
              Utils.removeLoading();
              sendDataToAdminNotification(adminUid, name);
              sendDataToAdminRequests(adminUid);
            } else {
              Utils.removeLoading();
            }
          } catch (e) {
            Utils.removeLoading();
            if (kDebugMode) {
              print(e.toString());
            }
          }
        }
      }
    }
  }

  Future sendDataToAdminNotification(admin, name) async {
    var ref = fireStore.collection(AppConstants.notification).doc(admin);
    ref.update({
      'notification':
          FieldValue.arrayUnion(["$name wants to join your committee"]),
    });
  }

  Future sendDataToAdminRequests(admin) async {
    var ref = fireStore.collection(AppConstants.committeeRequests).doc(admin);
    ref.update({
      'requests': FieldValue.arrayUnion([auth.currentUser!.uid]),
    });
  }
}
