import 'package:committee_app/utils/routes/route_name.dart';
import 'package:committee_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  FocusNode emailNode = FocusNode();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> resetPassword(BuildContext context, String email) async {
    isLoading = true;
    notifyListeners();
    try {
      await auth.sendPasswordResetEmail(email: email);
      // Password reset email sent successfully
      Utils.successMessage(context, "Password reset email sent to $email");
      isLoading = false;
      notifyListeners();
      Navigator.pushNamedAndRemoveUntil(context, RouteNames.forgotPasswordScreen, (route) => false);
    } catch (e) {
      // An error occurred
      Utils.errorMessage(context, "Failed to send email");
      isLoading = false;
      notifyListeners();
      print('Failed to send password reset email: $e');
    }
  }
}
