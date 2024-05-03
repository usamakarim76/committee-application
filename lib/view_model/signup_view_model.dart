import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/components/pop_over_widget.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/text_constants.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class SignUpViewModel extends ChangeNotifier {
  BuildContext context;
  SignUpViewModel(this.context);

  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final userPhoneNumberController = TextEditingController();
  final userAddressController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode userNameNode = FocusNode();
  FocusNode userPhoneNode = FocusNode();
  FocusNode userAddressNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ImagePicker imagePicker = ImagePicker();
  String error = '';
  String? userImage;
  bool isLoading = false, isGoogleLoading = false;

  Future registerUser() async {
    try {
      isLoading = true;
      notifyListeners();
      await auth
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) {
        dataToFirestore(userNameController.text, emailController.text);
        userNameController.clear();
        emailController.clear();
        passwordController.clear();
        isLoading = false;
        notifyListeners();
      });
      Utils.successMessage(context, "Registered Successfully");
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.loginScreen, (route) => false);
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      error = e.message!;
      Utils.errorMessage(context, error);
    }
  }

  Future dataToFirestore(name, email) async {
    await firestore
        .collection(AppConstants.userCollectionName)
        .doc(auth.currentUser!.uid)
        .set({
      'Name': name,
      'Email': email,
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
        dataToFirestore(user!.displayName, user.email);
        Utils.successMessage(context, "Log in successfully");
        isGoogleLoading = false;
        notifyListeners();
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.mainScreen, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      isGoogleLoading = false;
      notifyListeners();
      Utils.errorMessage(context, e.message);
    }
  }

  Future pickImage(source) async {
    try {
      XFile? image = await imagePicker.pickImage(source: source);
      if (image == null) {
        Utils.errorMessage(context, "Select image");
      } else {
        userImage = image.path;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void settingModalBottomSheet(
      context, cameraOnPress, galleryOnPress) {
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
