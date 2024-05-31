import 'package:committee_app/firebase_options.dart';
import 'package:committee_app/utils/routes/route.dart';
import 'package:committee_app/utils/routes/route_name.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 930),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // theme: ThemeData(primaryColor: AppColors.kWhiteColor
          // primarySwatch: Colors.blue,
          // textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          // ),
          initialRoute: RouteNames.splashScreen,
          onGenerateRoute: Routes.generateRoute,
          home: child,
        );
      },
    );
  }
}
