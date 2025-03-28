import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_chat_app_firebase/controllers/providers/sign_in_provider.dart';
import 'package:new_chat_app_firebase/controllers/providers/sign_up_provider.dart';
import 'package:new_chat_app_firebase/firebase_options.dart';
import 'package:new_chat_app_firebase/views/screens/auth_module/sign_up_screen.dart';
import 'package:new_chat_app_firebase/views/screens/splash_screen_module/splash_screen.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use the generated options
  );
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SignUpProvider()),
          ChangeNotifierProvider(create: (_) => SignInProvider())
    ],
        child:  MyApp())
      );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home://HomeScreen()
        //OtpVerificationScreen()
        //ForgotPasswordScreen()
        //SignUpScreen()
        //SignInScreen(),
        // OnboardingScreen(),
        SplashScreen(),
        //TestApp(),
        //const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}