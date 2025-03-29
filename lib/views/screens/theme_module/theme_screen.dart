import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_chat_app_firebase/controllers/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  // get current user profile
  Stream<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserProfile(){
    return FirebaseFirestore.instance.collection('chat_app_info').doc(currentUser).snapshots();
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
        child: Consumer<ThemeProvider>(
          builder: (context,provider,child){
            return Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
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
                      padding: const EdgeInsets.only(top: 20),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 90),
                          child: Center(
                              child: Text(
                                'Settings',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                    stream: getCurrentUserProfile(),
                    builder: (context,snapshot){
                      if(snapshot.hasError){
                        return Center(child: Text('Something went wrong'));
                      }else if(!snapshot.hasData && snapshot.data == null){
                        return Center(child: Text('user not found'));
                      }
                      else{
                        var data = snapshot.data!.data();
                        if(data == null || data.containsValue('imageUrl')){
                          return Center(child: Text('image not available'));
                        }
                        print('Fetch data -------->${data}');
                        print("Image URL: ${data['imageUrl']}");
                        return Column(
                          children: [
                            Container(
                              width : double.infinity,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  radius : 30,
                                  backgroundImage: data['imageUrl'] != null && data['imageUrl'].isNotEmpty
                                      ? (data['imageUrl'].startsWith('http') // Check if it's an online URL
                                      ? NetworkImage(data['imageUrl']) as ImageProvider
                                      : FileImage(File(data['imageUrl']))) // Use FileImage for local paths
                                      : AssetImage('assets/images/user_profile_image.png') as ImageProvider, // Default image
                                ),
                                title:Text(data['user name'] ?? 'no name',style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w600),),
                                subtitle: Text(data['email'] ?? 'no email',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),
                              ),
                            ),
                          ],
                        );
                      }

                    }),
                SizedBox(height: 10,),
                Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Theme mode',style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w500),),
                    SizedBox(height: 5,),
                    Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15)
                          //color: Colors.green
                        ),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: provider.isActive ? Text('Dark mode',style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500,
                              color: provider.isActive ? Colors.black26 : Colors.black87),):
                              Text('Light mode',style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500,
                                  color: provider.isActive ? Colors.white : Colors.black87),)
                            ),
                            Switch(
                                value: provider.isActive,
                                onChanged: (value){
                                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            })
                          ],
                        )
                    ),
                  ],
                )
              ],
            );
          }

        ),
      ),
    );
  }
}
