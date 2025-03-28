import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_chat_app_firebase/views/screens/auth_module/sign_in_screen.dart';
import 'package:new_chat_app_firebase/views/screens/home_screen_module/users_chatting_screen.dart';
import 'package:new_chat_app_firebase/views/screens/user_profile_module/user_profile_screen.dart';

class HomeChattingScreen extends StatefulWidget {
  const HomeChattingScreen({super.key});

  @override
  State<HomeChattingScreen> createState() => _HomeChattingScreenState();
}

class _HomeChattingScreenState extends State<HomeChattingScreen> {
  // get user
  Stream<QuerySnapshot> getUser() {
    String currentUser = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('chat_app_info')
        .where('uid', isNotEqualTo: currentUser)
        .snapshots();
  }

  final firebase = FirebaseAuth.instance;
  // Logout
 /* Future<void> logoutAccount() async {
    await FirebaseAuth.instance.signOut();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
      PopupMenuButton(
        padding: EdgeInsets.zero,
        color: Colors.grey.shade300,
      constraints: BoxConstraints(
        minHeight: 10,
        minWidth: 10
      ),
      icon: Icon(Icons.more_vert), // Use icon directly
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: true,
          child: Text('User Profile',style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w500),),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen()));
          },
        ),

        ]
          )
    ],
        title: Text(
          'Chatting',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey)
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.search,size: 26,color: Colors.grey,),
                  ),
                  SizedBox(width: 10,),
                  Text('Find user here',style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey
                  ),)
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
            stream: getUser(),
            builder: (context, snapshot) {
              // Handle null data properly
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No Data Found'));
              }

              // Extract data safely after checks
              var userData = snapshot.data!.docs;

              return Expanded(
                child: ListView.builder(
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    var userData = snapshot.data!.docs;
                    var showData = userData[index].data() as Map<String, dynamic>;
                
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UsersChattingScreen(
                              userName: showData['user name'] ?? 'Unknown User',
                              uid: showData['uid'] ?? '',
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: showData['imageUrl'] != null && showData['imageUrl'].isNotEmpty
                                  ? (showData['imageUrl'].startsWith('http') // Check if it's an online URL
                                  ? NetworkImage(showData['imageUrl']) as ImageProvider
                                  : FileImage(File(showData['imageUrl']))) // Use FileImage for local paths
                                  : AssetImage('assets/images/user_profile_image.png') as ImageProvider, // Default image
                            ),
                            title: Text(showData['user name'] ?? 'Unknown',style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w500),),
                            subtitle: Text(showData['email'] ?? 'No email available',style: GoogleFonts.poppins(fontSize: 13),),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
