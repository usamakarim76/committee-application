import 'package:committee_app/resources/colors.dart';
import 'package:flutter/cupertino.dart';

class LoadingWidget extends StatelessWidget {
  final Color color;
  const LoadingWidget({super.key, this.color = AppColors.kSecondaryColor});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      color: color,
      radius: 15,
    );
  }
}
