import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:new_chat_app_firebase/views/screens/auth_module/sign_up_screen.dart';
import 'package:new_chat_app_firebase/views/screens/home_screen_module/home_chatting_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void currentUserExists(){
    try{
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      if(currentUser.isNotEmpty){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeChattingScreen()));
        print('Yes user found');
      }else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
        print('No user found');
      }
    }catch(e){
      print('User not exists');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 4), currentUserExists);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(text: TextSpan(
              children: [
                TextSpan(text: '         Welcome\n',style: GoogleFonts.poppins(fontSize: 20,color: CupertinoColors.black,fontWeight: FontWeight.w700)),
                TextSpan(text: 'To Chatting App!!',style: GoogleFonts.poppins(fontSize: 20,color: CupertinoColors.black,fontWeight: FontWeight.w700)),
              ]
            )),
            SizedBox(height: 30,),
            Lottie.asset('assets/images/Animation - 1741951494828.json',height: 130)
          ],
        ),
      ),
    );
  }
}
