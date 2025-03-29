import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_chat_app_firebase/controllers/providers/sign_in_provider.dart';
import 'package:new_chat_app_firebase/views/components/button_widget.dart';
import 'package:new_chat_app_firebase/views/components/custom_textfield.dart';
import 'package:new_chat_app_firebase/views/screens/auth_module/sign_up_screen.dart';
import 'package:new_chat_app_firebase/views/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:new_chat_app_firebase/views/screens/home_screen_module/home_chatting_screen.dart';
import 'package:new_chat_app_firebase/views/screens/home_screen_module/home_screen.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<SignInProvider>(
      builder: (context,provider,child){
        return  Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                            child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 15.sp,),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    Text('Sign in now',style: GoogleFonts.poppins(fontSize: 26.sp,fontWeight: FontWeight.w600),),
                    SizedBox(height: 10.h,),
                    Text('Please sign in to continue our app',style: GoogleFonts.poppins(fontSize: 16.sp,fontWeight: FontWeight.w400,color: Colors.grey),),
                    SizedBox(height: 30.h,),
                    CustomTextField(hintText: 'Enter your email', controller: emailController, textInputType: TextInputType.emailAddress,prefixIcon: Icons.email,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Please enter your email';
                        }
                        return null;
                      },),
                    SizedBox(height: 30.h,),
                    CustomTextField(hintText: 'Enter your password', controller: passwordController, textInputType: TextInputType.number,postfixIcon: Icons.visibility,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Please enter your password';
                        }
                        if(value.length < 8){
                          return 'Please password must be 8 character';
                        }
                        return null;
                      },),
                    SizedBox(height: 10.h,),
                    Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                            },
                            child: Text('Forget Password?',style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w500),))),
                    SizedBox(height: 30.h,),
                    ButtonWidget(text: isLoading ? 'Loading...' : 'Sign in', color: Colors.black87,voidCallback: ()async{
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          isLoading = true;
                        });
                        try{
                          User? user = await provider.userSignIn(emailController.text, passwordController.text);
                          if(user != null){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Successfully')));
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeChattingScreen()));
                            print('User ------->${user.uid}');
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Doesn't exists")));
                          }
                          setState(() {
                            isLoading = false;
                          });
                        } catch(e){
                          print('Error -------->${e}');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User does not exists')));
                          setState(() {
                            isLoading = false;
                          });
                        }finally{
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },),
                    SizedBox(height: 30.h,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                      },
                      child: RichText(text: TextSpan(
                          children: [
                            TextSpan(text: 'Don’t have an account?',style: GoogleFonts.poppins(color: Colors.grey,fontSize: 14.sp,fontWeight: FontWeight.w400)),
                            TextSpan(text: ' Sign up',style:GoogleFonts.poppins(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black87),
                            )
                          ]
                      )),
                    ),
                    SizedBox(height: 60.h,),
                    Text('OR',style: GoogleFonts.poppins(fontSize: 14.sp,fontWeight:FontWeight.w400),),
                    SizedBox(height: 60.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.facebook,color: Colors.blue,size: 44,),
                        Image.asset('assets/images/Google-Symbol.png',height: 36,),
                        Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              shape: BoxShape.circle
                          ),
                          child:Center(child: Text('Phone',style: GoogleFonts.poppins(fontSize: 8,color: Colors.white),)) ,
                        )

                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
