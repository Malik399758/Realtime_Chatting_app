import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_chat_app_firebase/controllers/providers/sign_up_provider.dart';
import 'package:new_chat_app_firebase/views/components/button_widget.dart';
import 'package:new_chat_app_firebase/views/components/custom_textfield.dart';
import 'package:new_chat_app_firebase/views/screens/auth_module/sign_in_screen.dart';
import 'package:new_chat_app_firebase/views/screens/home_screen_module/home_chatting_screen.dart';
import 'package:new_chat_app_firebase/views/screens/home_screen_module/home_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  File? _image;
  final imagePicker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  final fireBase = FirebaseAuth.instance;

  // get image from gallery
  Future<void> getImageFromGallery() async{
    try{
      final selectedImageGallery = await imagePicker.pickImage(source: ImageSource.gallery);
      if(selectedImageGallery != null){
        setState(() {
          _image = File(selectedImageGallery.path);
        });
      }else{
        print('No Image selected from gallery');
      }
    } catch(e){
      print('Image selected error from gallery $e');
    }
  }

  // upload image on firebase storage
  Future<String?> uploadImageOnFireBaseStorage(String userId) async{
    try{
      // create directory
      Reference reference =  await FirebaseStorage.instance.ref().child('yaseen_chatting_app_images_directory/$userId.jpg');

      // upload image
      final uploadTask = await reference.putFile(_image!);

      // download url
      String downLoadUrl = await reference.getDownloadURL();
      print('Download url ------------>$downLoadUrl');
      return downLoadUrl;
    }catch(e){
      print('Upload image error --------->$e');
      return null;
    }

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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
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
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundImage: _image == null ? AssetImage('assets/images/user_profile_image.png') : FileImage(_image!.absolute),
                    ),
                    Positioned(
                      bottom: -5,
                      right: -2,
                      child: Container(
                        width: 22.w,
                        height: 22.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.shade300
                        ),
                        child: GestureDetector(
                          onTap: (){
                            // open bottom sheet
                            bottomSheet();
                          },
                            child: Icon(Icons.add,size: 15,color: Colors.white,)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.h,),
                Text('Sign up now',style: GoogleFonts.poppins(fontSize: 26.sp,fontWeight: FontWeight.w600),),
                SizedBox(height: 10.h,),
                Text('Please fill the details and create account',style: GoogleFonts.poppins(fontSize: 16.sp,fontWeight: FontWeight.w400,color: Colors.grey),textAlign: TextAlign.center,),
                SizedBox(height: 30.h,),
                CustomTextField(hintText: 'Enter your name', controller: nameController, textInputType: TextInputType.text,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please name must required *';
                  }
                  return null;
                },),
                SizedBox(height: 30.h,),
                CustomTextField(hintText: 'Enter your email', controller: emailController, textInputType: TextInputType.emailAddress,prefixIcon: Icons.email,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please email must required *';
                  }
                  return null;

                },),
                SizedBox(height: 30.h,),
                CustomTextField(hintText: 'Enter your password', controller: passwordController, textInputType: TextInputType.number,postfixIcon: Icons.visibility,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please password must required *';
                  }
                  if(value.length < 8){
                    return 'Password must be 8 character *';
                  }
                  return null;
                },),
                SizedBox(height: 10.h,),
                Align(
                  alignment: Alignment.topLeft,
                    child: Text('Password must be 8 character',style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.grey),)),
                SizedBox(height: 30.h,),
                ButtonWidget(text: isLoading ? 'Loading ...' :'Sign Up', color: Colors.black87,voidCallback: ()async{
                  if(_formKey.currentState!.validate()){
                    final provider = Provider.of<SignUpProvider>(context,listen: false);
                    setState(() {
                      isLoading = true;
                    });
                    try{
                     UserCredential userID = await fireBase.createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully')));
                      print('User ID : --------------->${userID.user!.uid}');
                      provider.userSignUpDetail(
                          userID.user!.uid,
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                          _image!.path,
                      );
                      uploadImageOnFireBaseStorage(userID.user!.uid);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeChattingScreen()));
                      setState(() {
                        isLoading = false;
                      });
                    } on FirebaseException catch(error){
                      print('Firebase authentication error --------->${error.message}');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong')));
                    }catch(e){
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                  },
                  child: RichText(text: TextSpan(
                      children: [
                        TextSpan(text: 'Already have an account ?',style: GoogleFonts.poppins(color: Colors.grey,fontSize: 14.sp,fontWeight: FontWeight.w400)),
                        TextSpan(text: ' Sign in',style:GoogleFonts.poppins(fontSize: 14.sp,fontWeight: FontWeight.w500,color: Colors.black87),
                        )
                      ]
                  )),
                ),
                SizedBox(height: 10.h,),
                Text('OR',style: GoogleFonts.poppins(fontSize: 14.sp,fontWeight:FontWeight.w400),),
                SizedBox(height: 10.h,),
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
  }
  // bottom sheet
  Future<void> bottomSheet(){
    return showModalBottomSheet(context: context, builder: (BuildContext context){
      return Container(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: (){
              getImageFromGallery();
              Navigator.pop(context);
            }, icon: Icon(Icons.image,size: 50,)),
            IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.camera_fill,size: 50,))
          ],
        ),
      );
    });
  }
}
