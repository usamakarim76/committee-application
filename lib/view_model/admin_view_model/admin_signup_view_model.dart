import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/components/pop_over_widget.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class AdminSignUpViewModel extends ChangeNotifier {
  BuildContext context;
  AdminSignUpViewModel(this.context);

  final adminEmailController = TextEditingController();
  final adminNameController = TextEditingController();
  final adminPhoneNumberController = TextEditingController();
  final adminAddressController = TextEditingController();
  final adminPasswordController = TextEditingController();
  FocusNode adminEmailNode = FocusNode();
  FocusNode adminNameNode = FocusNode();
  FocusNode adminPhoneNode = FocusNode();
  FocusNode adminAddressNode = FocusNode();
  FocusNode adminPasswordNode = FocusNode();
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);
  final FirebaseAuth auth = FirebaseAuth.instance;
  fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ImagePicker imagePicker = ImagePicker();
  String error = '', adminImage = '';
  String? imageURL;
  bool isLoading = false, isGoogleLoading = false;

  Future registerAdmin() async {
    try {
      print("object");
      isLoading = true;
      notifyListeners();
      File? imageFile = File(adminImage);
      imageURL = await uploadImageToFirebase(imageFile);
      await auth
          .createUserWithEmailAndPassword(
        email: adminEmailController.text.trim(),
        password: adminPasswordController.text.trim(),
      )
          .then((value) {
        dataToFireStore(
                adminNameController.text,
                adminEmailController.text,
                adminPhoneNumberController.text,
                adminAddressController.text,
                imageURL)
            .then((value) => {
                  isLoading = false,
                  notifyListeners(),
                  Utils.successMessage(context, "Registered Successfully"),
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteNames.loginScreen, (route) => false),
                  signOut(),
                })
            .onError((error, stackTrace) => {
                  Utils.errorMessage(context, error),
                });
        isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      error = e.message!;
      Utils.errorMessage(context, error);
    }
  }

  Future signOut() async {
    await auth.signOut();
  }

  Future dataToFireStore(
      userName, userEmail, phoneNumber, userAddress, image) async {
    CollectionReference user =
        firestore.collection(AppConstants.userDataCollectionName);
    QuerySnapshot querySnapshot = await user.get();
    int count = querySnapshot.docs.length;
    await firestore
        .collection(AppConstants.userDataCollectionName)
        .doc(auth.currentUser!.uid)
        .set({
      'Id': count + 1,
      'Name': userName ?? "",
      'Email': userEmail ?? "",
      'PhoneNumber': phoneNumber ?? "",
      'Address': userAddress ?? "",
      'Role': 'Admin',
      'DeviceToken': "",
      'ProfileImage': image ?? "",
      'CreatedAT': DateTime.now().toString()
    });
  }

  Future<void> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      googleSignIn.signOut();
      isGoogleLoading = true;
      notifyListeners();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        UserCredential result = await auth.signInWithCredential(authCredential);
        User? user = result.user;
        dataToFireStore(user!.displayName, user.email, user.phoneNumber, "",
                user.photoURL)
            .then((value) => {
                  Utils.successMessage(context, "Log in successfully"),
                  isGoogleLoading = false,
                  notifyListeners(),
                  Navigator.pushNamedAndRemoveUntil(context,
                      RouteNames.adminDashBoardScreen, (route) => false),
                })
            .onError((error, stackTrace) => {
                  Utils.errorMessage(context, error),
                });
        isGoogleLoading = false;
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      isGoogleLoading = false;
      notifyListeners();
      Utils.errorMessage(context, e.message);
    }
  }

  // Method to upload image to Firebase Storage
  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      fs.Reference storageReference =
          storage.ref().child('images/${adminNameController.text + imageName}');
      fs.UploadTask uploadTask = storageReference.putFile(imageFile);
      fs.TaskSnapshot storageSnapshot =
          await uploadTask.whenComplete(() => null);
      String downloadURL = await storageSnapshot.ref.getDownloadURL();
      print("Image uploaded successfully. Download URL: $downloadURL");
      return downloadURL;
    } catch (e) {
      if (kDebugMode) {
        print("Error uploading image: $e");
      }
      return null;
    }
  }

  Future pickImage(source) async {
    try {
      XFile? image = await imagePicker.pickImage(source: source);
      if (image == null) {
        Utils.errorMessage(context, "Select image");
      } else {
        adminImage = image.path;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void settingModalBottomSheet(context, cameraOnPress, galleryOnPress) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Popover(
            child: Container(
              height: 170.h,
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 5.h,
                  ),
                  ListTile(
                      leading: const Icon(
                        Icons.camera_alt_outlined,
                        color: Color(0xff767676),
                      ),
                      title: Text('Camera',
                          style: textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.w100)),
                      onTap: cameraOnPress),
                  ListTile(
                    leading: const Icon(
                      Icons.perm_media_outlined,
                      color: Color(0xff767676),
                    ),
                    title: Text('Gallery',
                        style: textTheme.titleSmall!
                            .copyWith(fontWeight: FontWeight.w100)),
                    onTap: galleryOnPress,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
