import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/model/user_model.dart' as user;
import 'package:committee_app/resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AdminRequestViewModel extends ChangeNotifier {
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
    return requests;
  }

  Future rejectRequest(userUid) async {
    isLoading = true;
    notifyListeners();
    print(userUid);
    try {
      var ref = fireStore
          .collection(AppConstants.committeeRequests)
          .doc(auth.currentUser!.uid);
      await ref.update({
        'requests': FieldValue.arrayRemove([userUid])
      }).then((value) => {rejectRequestDataToNotification(userUid, "name")});
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      isLoading = false;
      notifyListeners();
    }
  }

  Future rejectRequestDataToNotification(user, name) async {
    var ref = fireStore.collection(AppConstants.notification).doc(user);
    ref.update({
      'notification': FieldValue.arrayUnion(
          ["$name reject your Committee joining request"]),
    });
  }
}
