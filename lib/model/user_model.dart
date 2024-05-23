import 'package:cloud_firestore/cloud_firestore.dart';

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