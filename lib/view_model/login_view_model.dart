import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/constants.dart';
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
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String error = '';
  bool isLoading = false, isGoogleLoading = false;

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
      isLoading = false;
      notifyListeners();
      Utils.successMessage(context, "Log in successfully");
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      error = e.message!;
      Utils.errorMessage(context, error);
    }
  }

  Future getCurrentUserRole() async {
    DocumentSnapshot snapshot = await firestore
        .collection(AppConstants.userDataCollectionName)
        .doc(auth.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      print("object");
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      if (userData['Role'] == "Admin") {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.adminDashBoardScreen, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.userDashBoardScreen, (route) => false);
      }
    } else {
      Utils.errorMessage(context, "No user found");
    }
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

  Future dataToFirestore(name, email) async {
    await firestore
        .collection(AppConstants.userDataCollectionName)
        .doc(auth.currentUser!.uid)
        .set({
      'Name': name,
      'Email': email,
    });
  }
}
