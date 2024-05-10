import 'dart:convert';

import 'package:committee_app/resources/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserJoinCommitteeViewModel extends ChangeNotifier {
  Future sendNotificationToAdmin() async {
    print("object");
    try {
      var url = Uri.parse("https://fcm.googleapis.com/fcm/send");
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=${AppConstants.apiKey}'
      };
      var body = {
        'to':      'd7yS_JRsRI-mSaXiTx5nnz:APA91bGlhsC9c9WE3rYSPLSXEnXBLL439fGD6ugIAFXo2YMmpoP0YxYJ5mc5fPZEHKEpnQZw4jnWYdurGCxujz7kpaFNrRnE8ayK90Wryh1mkta1_3nS6lIRYE3c5mc-qSUb9FXU_QLd' ,'priority': 'high',
        'notification': {
          'title': "Usama",
          'body': "hey theere",
        }
      };
      await http.post(url, body: jsonEncode(body), headers: headers);
    } catch (e) {
      print(e.toString());
    }
  }
}
