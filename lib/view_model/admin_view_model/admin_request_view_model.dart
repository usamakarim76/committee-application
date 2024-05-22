import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AdminRequestViewModel extends ChangeNotifier {

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<List<User>> getRequestsForUser() async {
    List<User> requests = [];
    // Retrieve sent requests
    DocumentSnapshot sentSnapshot = await fireStore
        .collection(AppConstants.committeeRequests)
        .doc(auth.currentUser!.uid)
        .get();
    print("object");
    var data = sentSnapshot.data() as Map<String, dynamic>?;
    if (data != null && data['requests'] != null) {
      List<dynamic> sentRequestIds = data['requests'];
      for (String requestId in sentRequestIds) {
        print("Asdasas");
        DocumentSnapshot userSnapshot = await fireStore
            .collection(AppConstants.userDataCollectionName)
            .doc(requestId)
            .get();
        print("ssss");
        if (userSnapshot.exists) {
          requests.add(User.fromSnapshot(userSnapshot));
          print("qwqwqwqw");
        }
      }
    }
    print(requests[0].deviceToken);
    // List<dynamic> sentRequestIds = sentSnapshot.data()['requests'];
    // for (String requestId in sentRequestIds) {
    //   DocumentSnapshot userSnapshot =
    //       await fireStore.collection(AppConstants.userDataCollectionName).doc(requestId).get();
    //   requests.add(User.fromSnapshot(userSnapshot));
    // }
    return requests;
  }
}

class User {
  final String address;
  final Timestamp createdAt;
  final String deviceToken;
  final String email;
  final int id;
  final String name;
  final String phoneNumber;
  final String profileImage;
  final String role;
  final String userUid;

  User({
    required this.address,
    required this.createdAt,
    required this.deviceToken,
    required this.email,
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.profileImage,
    required this.role,
    required this.userUid,
  });

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return User(
      address: data['Address'] ?? '',
      createdAt: data['CreatedAt'] ?? Timestamp.now(),
      deviceToken: data['DeviceToken'] ?? '',
      email: data['Email'] ?? '',
      id: data['Id'] ?? '',
      name: data['Name'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      profileImage: data['ProfileImage'] ?? '',
      role: data['Role'] ?? '',
      userUid: data['UserUid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Address': address,
      'CreatedAt': createdAt,
      'DeviceToken': deviceToken,
      'Email': email,
      'Id': id,
      'Name': name,
      'PhoneNumber': phoneNumber,
      'ProfileImage': profileImage,
      'Role': role,
      'UserUid': userUid,
    };
  }
}
