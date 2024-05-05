import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:committee_app/resources/constants.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  ForgotPasswordViewModel(this.context);
  BuildContext context;
  final TextEditingController emailController = TextEditingController();
  FocusNode emailNode = FocusNode();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  // Future<void> resetPassword(BuildContext context, String email) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     await auth
  //         .sendPasswordResetEmail(email: email)
  //         .onError((error, stackTrace) {
  //               print(error);
  //             });
  //     // Password reset email sent successfully
  //     Utils.successMessage(context, "Password reset email sent to $email");
  //     isLoading = false;
  //     notifyListeners();
  //     Navigator.pushNamedAndRemoveUntil(
  //         context, RouteNames.loginScreen, (route) => false);
  //   } catch (e) {
  //     // An error occurred
  //     Utils.errorMessage(context, "Failed to send email");
  //     isLoading = false;
  //     notifyListeners();
  //     print('Failed to send password reset email: $e');
  //   }
  // }

  Future<void> resetPassword(String email) async {
    try {
      isLoading = true;
      notifyListeners();
      bool emailExists = await isEmailInFireStore(email);
      if (!emailExists) {
        isLoading = false;
        notifyListeners();
        Utils.errorMessage(context, "Email is invalid");
      } else {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        Utils.successMessage(context, "Password reset email sent to $email");
        isLoading = false;
        notifyListeners();
        Navigator.pop(context);
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('Failed to send password reset email: $e');
    }
  }

  Future<bool> isEmailInFireStore(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(AppConstants.userDataCollectionName)
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        if (doc['Email'] == email) {
          print(doc['Email']);
          print(email);
          print("object");
          return true;
        }
      }

      // If no document has the specified email, return false
      return false;
    } catch (e) {
      // Error occurred while querying Firestore
      print('Error checking email in Firestore: $e');
      return false;
    }
  }
}
