import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/model/user_model.dart' as user;
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/shared_preferences/shared_preferences.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AdminRequestViewModel extends ChangeNotifier {
  AdminRequestViewModel(this.context);
  BuildContext context;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  Future<List<user.User>> getRequestsForUser() async {
    List<user.User> requests = [];
    // Retrieve sent requests
    DocumentSnapshot sentSnapshot = await fireStore
        .collection(AppConstants.committeeRequests)
        .doc(auth.currentUser!.uid)
        .get();
    var data = sentSnapshot.data() as Map<String, dynamic>?;
    if (data != null && data['requests'] != null) {
      List<dynamic> sentRequestIds = data['requests'];
      for (String requestId in sentRequestIds) {
        DocumentSnapshot userSnapshot = await fireStore
            .collection(AppConstants.userDataCollectionName)
            .doc(requestId)
            .get();
        if (userSnapshot.exists) {
          requests.add(user.User.fromSnapshot(userSnapshot));
        }
      }
    }
    Utils.removeLoading();
    return requests;
  }

  Future rejectRequest(userUid) async {
    Utils.showLoading();
    print(userUid);
    try {
      var ref = fireStore
          .collection(AppConstants.committeeRequests)
          .doc(auth.currentUser!.uid);
      await ref.update({
        'requests': FieldValue.arrayRemove([userUid])
      }).then((value) => {rejectRequestDataToNotification(userUid)});
      Utils.removeLoading();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      Utils.removeLoading();
    }
  }

  Future rejectRequestDataToNotification(user) async {
    print(user);
    String? userName = await SharedPreferencesHelper.getUsername();
    print(userName);
    var ref = fireStore.collection(AppConstants.notification).doc(user);
    ref.update({
      'notification': FieldValue.arrayUnion(
          ["$userName reject your Committee joining request"]),
    });
    sendNotificationToUser(user);
  }

  Future sendNotificationToUser(userId) async {
    var data = await fireStore
        .collection(AppConstants.userDataCollectionName)
        .doc(userId)
        .get();
    if (data['DeviceToken'] == " ") {
      Utils.removeLoading();
      // sendDataToAdminNotification(adminUid, name);
      // sendDataToAdminRequests(adminUid);
    } else {
      var userName = await SharedPreferencesHelper.getUsername();
      print(userName);
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
            'body': "$userName reject your committee joining request",
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

  void updateData() {
    Utils.showLoading();
    notifyListeners();
  }

  Future acceptRequest(userUid, userName) async {
    Utils.showLoading();
    print(userUid);
    try {
      var ref = fireStore
          .collection(AppConstants.committeeRequests)
          .doc(auth.currentUser!.uid);
      await ref.update({
        'requests': FieldValue.arrayRemove([userUid])
      }).then((value) => {acceptRequestDataToNotification(userUid)});
      await fireStore
          .collection(AppConstants.adminCommittee)
          .doc(auth.currentUser!.uid)
          .update({
        'members_list': FieldValue.arrayUnion([userUid])
      });
      addUserNameToCommittee(userName);

      Utils.removeLoading();
      notifyListeners();
    } catch (e) {
      Utils.removeLoading();

      print(e.toString());
    }
  }

  Future acceptRequestDataToNotification(user) async {
    print(user);
    String? userName = await SharedPreferencesHelper.getUsername();
    print(userName);
    var ref = fireStore.collection(AppConstants.notification).doc(user);
    ref.update({
      'notification': FieldValue.arrayUnion(
          ["$userName accept your Committee joining request"]),
    });
    sendAcceptNotificationToUser(user);
  }

  Future sendAcceptNotificationToUser(userId) async {
    var data = await fireStore
        .collection(AppConstants.userDataCollectionName)
        .doc(userId)
        .get();
    if (data['DeviceToken'] == " ") {
      Utils.removeLoading();
    } else {
      var userName = await SharedPreferencesHelper.getUsername();
      print(userName);
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
            'body': "$userName accept your committee joining request",
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

  Future addUserNameToCommittee(String userName) async {
    var ref = fireStore
        .collection(AppConstants.adminCommittee)
        .doc(auth.currentUser!.uid);
    ref.update({
      'committee_members_name': FieldValue.arrayUnion([userName]),
    });
  }
}
