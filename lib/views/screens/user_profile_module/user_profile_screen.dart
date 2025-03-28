import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_chat_app_firebase/views/screens/auth_module/sign_in_screen.dart';
import 'package:new_chat_app_firebase/views/screens/onboarding_module/onboarding_screen.dart';
import 'package:new_chat_app_firebase/views/screens/user_profile_module/edit_profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String userName = "";
  String userEmail = "";
  String profileImage = "";
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  // Fetch user info from FireStore
  Future<void> getUserInfo() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) return; // Ensure user is logged in

      final userDoc = await FirebaseFirestore.instance
          .collection('chat_app_info')
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;

        setState(() {
          userName = data['user name'] ?? "No Name"; // Keep space if necessary
          userEmail = user.email ?? "No Email";

          // Ensure the profile image is a valid URL
          String? fetchedImage = data['imageUrl'];
          profileImage = (fetchedImage != null && Uri.tryParse(fetchedImage)?.hasAbsolutePath == true)
              ? fetchedImage
              : "https://via.placeholder.com/150";
        });
      } else {
        debugPrint("User document doesn't exist.");
      }
    } catch (e) {
      debugPrint("Failed to fetch user info: $e");
    }
  }

  // get current user profile
  Stream<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserProfile(){
    return FirebaseFirestore.instance.collection('chat_app_info').doc(currentUser).snapshots();
  }



  File? _image;

  // delete account Dialog

  Future deleteAccountDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Are you sure you want to delete this'
                      ' Account ',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87)),
              TextSpan(
                text: 'Permanent?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ])),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      try {
                        deleteAccount();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Account deleted successfully')));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OnboardingScreen()));
                      } catch (e) {
                        print('Delete account error ------------>$e');
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Account deleted error!!')));
                      }
                    },
                    child: Container(
                      width: 90,
                      height: 26,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                          child: Text(
                        'Yes',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 90,
                      height: 26,
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(16)
                          //border: Border.all(color:Colors.red)
                          ),
                      child: Center(
                          child: Text(
                        'No',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  // logout account Dialog

  Future logoutAccountDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Are you sure you want to logout? ',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87)),
            ])),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      try {
                        logoutAccount();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Account logout successfully')));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()));
                      } catch (e) {
                        print('Logout Error --------->$e');
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Account logout Error')));
                      }
                    },
                    child: Container(
                      width: 90,
                      height: 26,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                          child: Text(
                        'Yes',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 90,
                      height: 26,
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(16)
                          //border: Border.all(color:Colors.red)
                          ),
                      child: Center(
                          child: Text(
                        'No',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      )),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  // logout account

  Future<void> logoutAccount() {
    return FirebaseAuth.instance.signOut();
  }

  // delete account
  Future<void> deleteAccount() {
    return FirebaseAuth.instance.currentUser!.delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
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
                      padding: const EdgeInsets.only(top: 30),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: Center(
                              child: Text(
                            'Profile',
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  //color: Colors.grey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
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
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                            width: 33,
                                            height: 33,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                shape: BoxShape.circle),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
                                                //bottomSheet();
                                              },
                                              child: Icon(
                                                Icons.edit_outlined,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Text(data['user name'] ?? 'no name',style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w600),),
                                  Text(data['email'] ?? 'no email',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),
                                ],
                              );
                            }

                          }),
                      SizedBox(
                        height: 5,
                      ),
                     /* Text(
                        '${userName} ',
                        style: GoogleFonts.poppins(
                            fontSize: 24, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '${userEmail}',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),*/
                      SizedBox(
                        height: 70,
                      ),
                      Container(
                        width: double.infinity,
                        height: 344,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.person,
                                        color: Colors.grey.shade700,
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        'Person',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    size: 24,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // logout account

                            GestureDetector(
                              onTap: () {
                                logoutAccountDialog();
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.logout,
                                          color: Colors.grey.shade700,
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          'Logout',
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      size: 24,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // delete account

                            GestureDetector(
                              onTap: () {
                                deleteAccountDialog();
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.delete_forever,
                                          color: Colors.grey.shade700,
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          'Delete Account',
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      size: 24,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.settings,
                                        color: Colors.grey.shade700,
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        'Settings',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    size: 24,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.doc_text_search,
                                        color: Colors.grey.shade700,
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        'Versions',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    size: 24,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
    ),
      ),
  );
  }

  // bottom sheet
  Future<void> bottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      // getImageFromGallery();
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.image,
                      size: 50,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.camera_fill,
                      size: 50,
                    ))
              ],
            ),
          );
        });
  }
}
