import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/app_notification.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/resources/shared_preferences/shared_preferences.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginViewModel extends ChangeNotifier {
  BuildContext context;
  LoginViewModel(this.context);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  AppNotifications appNotifications = AppNotifications();
  String error = '';
  String? deviceToken;
  bool isLoading = false, isGoogleLoading = false;

  Future getDeviceToken() async {
    deviceToken = await appNotifications.getDeviceToken();
    deviceTokenToFireStore(deviceToken!);
  }

  Future<void> signIn() async {
    try {
      isLoading = true;
      notifyListeners();
      await auth
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((value) => {
                getCurrentUserRole(),
              });
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      error = e.message!;
      Utils.errorMessage(context, error);
    }
  }

  Future getCurrentUserRole() async {
    DocumentSnapshot snapshot = await fireStore
        .collection(AppConstants.userDataCollectionName)
        .doc(auth.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      getDeviceToken();
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

      print(userData);
      if (userData['Role'] == "Admin") {
        isLoading = false;
        notifyListeners();
        // Navigator.pushNamedAndRemoveUntil(
        //     context, RouteNames.adminBottomNavBar, (route) => false);
      } else {
        isLoading = false;
        notifyListeners();
        // Navigator.pushNamedAndRemoveUntil(
        //     context, RouteNames.userBottomNavBar, (route) => false);
      }
      await SharedPreferencesHelper.
    } else {
      isLoading = false;
      notifyListeners();
      Utils.errorMessage(context, "No user found");
    }
  }

  Future deviceTokenToFireStore(String token) async {
    await fireStore
        .collection(AppConstants.userDataCollectionName)
        .doc(auth.currentUser!.uid)
        .update({"DeviceToken": token});
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
        // dataToFirestore(user!.displayName, user.email);
        Utils.successMessage(context, "Log in successfully");
        isGoogleLoading = false;
        notifyListeners();
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.adminDashBoardScreen, (route) => false);
      } else {
        isGoogleLoading = false;
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      isGoogleLoading = false;
      notifyListeners();
      Utils.errorMessage(context, e.message);
    }
  }

}
