import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_chat_app_firebase/views/components/button_widget.dart';
import 'package:new_chat_app_firebase/views/components/custom_textfield.dart';
import 'package:new_chat_app_firebase/views/screens/forgot_password_screen/otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final forgotPasswordController = TextEditingController();


  Future<void> emailCheckDialog(BuildContext context){
    return showDialog(context: context, builder: (_){
      return AlertDialog(
        title: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => OtpVerificationScreen()));
            Navigator.pop(context);
          },
          child: Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black87
            ),
            child: Icon(Icons.mark_email_unread,color: Colors.white,),
          ),
        ) ,
        content:Text('Check your email',style: GoogleFonts.poppins(fontSize: 18.sp,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
              child: Text('We have send password recovery instruction to your email',style: GoogleFonts.poppins(fontWeight: FontWeight.w400,fontSize: 16.sp),
              textAlign: TextAlign.center,))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 15.sp,),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            Text('Forgot password',style: GoogleFonts.poppins(fontSize: 26.sp,fontWeight: FontWeight.w600),),
            SizedBox(height: 10.h,),
            Text('Enter your email account to reset  your password',style: GoogleFonts.poppins(fontSize: 16.sp,fontWeight: FontWeight.w400,color: Colors.grey),textAlign: TextAlign.center,),
            SizedBox(height: 30.h,),
            CustomTextField(hintText: 'Enter your email', controller: forgotPasswordController, textInputType: TextInputType.emailAddress),
            SizedBox(height: 30.h,),
            ButtonWidget(text: 'Reset Password', color: Colors.black87,voidCallback: (){
              emailCheckDialog(context);
            },)
          ],
        ),
      ),
    );
  }
}
