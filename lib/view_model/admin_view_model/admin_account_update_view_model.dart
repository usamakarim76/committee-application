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
import 'package:image_picker/image_picker.dart';

class AdminAccountUpdateViewModel extends ChangeNotifier {
  AdminAccountUpdateViewModel(this.context);
  BuildContext context;
  ImagePicker imagePicker = ImagePicker();
  String adminImage = '';
  final adminNameController = TextEditingController();
  final adminPhoneNumberController = TextEditingController();
  final adminAddressController = TextEditingController();
  FocusNode adminNameNode = FocusNode();
  FocusNode adminPhoneNode = FocusNode();
  FocusNode adminAddressNode = FocusNode();
  FocusNode adminPasswordNode = FocusNode();
  final FirebaseAuth auth = FirebaseAuth.instance;
  fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? imageURL, error;
  bool isLoading = false;

  Future getUserData()async{
     await firestore.collection(AppConstants.userDataCollectionName).doc(auth.currentUser!.uid).get();
  }


  Future updateAdminAccount() async {
    try {
      isLoading = true;
      notifyListeners();
      File? imageFile = File(adminImage);
      imageURL = await uploadImageToFirebase(imageFile);
      dataToFireStore(adminNameController.text, adminPhoneNumberController.text,
              adminAddressController.text, imageURL)
          .then((value) => {
                isLoading = false,
                notifyListeners(),
                Utils.successMessage(context, "Account updated successfully"),
              })
          .onError((error, stackTrace) => {
                Utils.errorMessage(context, error),
              });
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      error = e.message!;
      Utils.errorMessage(context, error);
    }
  }

  Future dataToFireStore(userName, phoneNumber, userAddress, image) async {
    await firestore
        .collection(AppConstants.userDataCollectionName)
        .doc(auth.currentUser!.uid)
        .update({
      'Name': userName ?? "",
      'PhoneNumber': phoneNumber ?? "",
      'Address': userAddress ?? "",
      'ProfileImage': image ?? "",
      'UpdatedAt': DateTime.now().toString()
    });
  }

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
