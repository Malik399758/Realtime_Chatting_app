import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_chat_app_firebase/views/components/button_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  final updateNameController = TextEditingController();
  final updateEmailController = TextEditingController();
  final updatePasswordController = TextEditingController();


  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser(){
    return FirebaseFirestore.instance.collection('chat_app_info').doc(currentUser).snapshots();
  }

  // get user info
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserData(){
    return FirebaseFirestore.instance.collection('chat_app_info').doc(currentUser).snapshots();
  }

  // update user data
  Future<void> updateUserData()async{
    try{
      FirebaseFirestore.instance.collection('chat_app_info').doc(currentUser).update({
        'user name' : updateNameController.text,
        'email' : updateEmailController.text,
        'password' : updatePasswordController.text
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Updated data Successfully')));
    } catch(e){
      print('Update data error ------->$e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Updated data error')));
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
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 30.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 15.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 85),
                        child: Center(
                            child: Text(
                              'Edit Profile',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ))),
                  ),
                ],
              ),
              StreamBuilder(stream: getUser(),
                  builder: (context,snapshot){
                     if(snapshot.hasError){
                       return Text('Something went wrong');
                     }else if(!snapshot.hasData){
                       return Text('User name not found');
                     }else {
                       var data = snapshot.data!.data();
                       if(data == null || data.containsValue('imageUrl')){
                         return Text('Data not available');
                       }
                       updateNameController.text = data['user name'] ?? '';
                       updateEmailController.text = data['email'] ?? '';
                       updatePasswordController.text = data['password'] ?? '';
                       return Column(
                         children: [
                           SizedBox(height: 10,),
                           Stack(
                             children: [
                               CircleAvatar(
                                 radius: 50,
                                 backgroundImage: data['imageUrl'] != null && data['imageUrl'].isNotEmpty
                                     ? (data['imageUrl'].startsWith('http') // Check if it's an online URL
                                     ? NetworkImage(data['imageUrl']) as ImageProvider
                                     : FileImage(File(data['imageUrl']))) // Use FileImage for local paths
                                     : AssetImage('assets/images/user_profile_image.png') as ImageProvider, // Default image
                               ),
                             ],
                           ),
                           SizedBox(height: 10,),
                           Text(data['user name'] ?? 'no name',style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w600),),
                           SizedBox(height: 3,),
                           Text('Change Profile Picture',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                           SizedBox(height: 20,),
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Full name',style: GoogleFonts.poppins(fontSize: 19),),
                               SizedBox(height: 5,),
                               TextFormField(
                                 controller : updateNameController,
                                 decoration: InputDecoration(
                                   border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(12),
                                   )
                                 ),
                               ),
                               SizedBox(height: 5,),
                               Text('Email',style: GoogleFonts.poppins(fontSize: 19),),
                               SizedBox(height: 5,),
                               TextFormField(
                                 controller : updateEmailController,
                                 decoration: InputDecoration(
                                     border: OutlineInputBorder(
                                       borderRadius: BorderRadius.circular(12),
                                     )
                                 ),
                               ),
                               SizedBox(height: 5,),
                               Text('Password',style: GoogleFonts.poppins(fontSize: 19),),
                               SizedBox(height: 5,),
                               TextFormField(
                                 controller : updatePasswordController,
                                 decoration: InputDecoration(
                                     border: OutlineInputBorder(
                                       borderRadius: BorderRadius.circular(12),
                                     )
                                 ),
                               ),
                               SizedBox(height: 30,),
                               ButtonWidget(
                                   text: 'Update',
                                   color: Colors.black87,
                                   voidCallback: (){
                                     updateUserData();
                                   })
                             ],
                           )
          
                         ],
                       );
                     }
                  })
          
            ],
          ),
        ),
      ),
    );
  }
}

