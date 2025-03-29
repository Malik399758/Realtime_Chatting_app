import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_chat_app_firebase/models/user_chatting_model/user_chatting_model.dart';
import 'package:intl/intl.dart';

class UsersChattingScreen extends StatefulWidget {
  final String userName;
  final String uid;
  final String imageUrl;
  const UsersChattingScreen({super.key,required this.userName,required this.uid,required this.imageUrl});

  @override
  State<UsersChattingScreen> createState() => _UsersChattingScreenState();
}

class _UsersChattingScreenState extends State<UsersChattingScreen> {

  final messageController = TextEditingController();
  final String senderId = FirebaseAuth.instance.currentUser!.uid;
  final String? senderEmail = FirebaseAuth.instance.currentUser!.email;
  final String? senderName = FirebaseAuth.instance.currentUser!.displayName;
  final timeStamp = Timestamp.now();



  // Set data
  Future<void> setData(String message)async{
    try{
      print('Send message data ------->$senderId email : $senderEmail timestamp : $timeStamp receiver id ------->${widget.uid}');
      UserChattingModel userMessage = UserChattingModel(
          senderId: senderId,
          senderEmail: senderEmail.toString(),
          receiverId: widget.uid ,
          message: message,
          timestamp: timeStamp,
          senderName: senderName.toString(),
      );

      List<String> ids = [senderId,widget.uid];
      print('ids ------>$ids');
      ids.sort();
      final combineId = ids.join('_');

      await FirebaseFirestore.instance.collection('yaseen_chatting').doc(combineId).collection('yaseen_message').add(userMessage.toMap());

    }catch(error){
      print('Error ---------->$error');
    }


  }

  // get data
  Stream<QuerySnapshot<Map<String, dynamic>>> getData(){
    List<String> ids = [senderId,widget.uid];
    print('Ids --------->$ids');
    ids.sort();
    final combineIds = ids.join('_');
    return FirebaseFirestore.instance.collection('yaseen_chatting').doc(combineIds).collection('yaseen_message').orderBy(
      'timestamp',
      descending: false,
    ).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.imageUrl ?? '';
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: CircleAvatar(
            minRadius: 3,
            backgroundImage: imageUrl.isNotEmpty
                ? (imageUrl.startsWith('http')
                ? NetworkImage(imageUrl)
                : (imageUrl.startsWith('assets/') // Check if it's an asset
                ? const AssetImage('assets/images/user_profile_image.png',)
                : FileImage(File(imageUrl)))) as ImageProvider
                : const AssetImage('assets/default_avatar.png'),
          ),
        ),


        title: Text(widget.userName,style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w700),),
      ),
      body: Column(
        children: [
          Expanded(child: buildMessageList()),
          // Spacer(flex: 1,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                        hintText: 'Enter message here',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12,)
                        )
                    ),
                  ),
                ),
                IconButton(onPressed: (){
                  if(messageController.text.isNotEmpty){
                    setData(messageController.text);
                    messageController.clear();
                  }
                }, icon: Icon(Icons.send,size: 30,))
              ],
            ),
          ),
        ],
      ),
    );
  }

  // single message show

  Widget buildMessage(QueryDocumentSnapshot document){
    Map<String,dynamic> data = document.data() as Map<String,dynamic>;
    bool isCurrentUser = data['senderId'] == senderId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
      child: Column(
        children: [
          Align(
              alignment: isCurrentUser ? Alignment.centerRight  : Alignment.centerLeft,
              child: Text(data['senderEmail'],style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w600))),
          SizedBox(height: 10,),
          Container(
            alignment: isCurrentUser ? Alignment.centerRight  : Alignment.centerLeft,
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue.shade200 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12)
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(data['message'] ?? 'no message',style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w600),),
                ),
              ],
            ),
          ),
          Align(
            alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              DateFormat('hh:mm a').format(
                (data['timestamp'] as Timestamp).toDate(), // Convert Timestamp to DateTime
              ),
              style: TextStyle(fontSize: 14, color: Colors.grey), // Optional styling
            ),
          )
        ],
      ),
    );
  }


  // List of message

  Widget buildMessageList(){
    return StreamBuilder<QuerySnapshot>(
        stream: getData(),
        builder: (context,snapshot){

          if(snapshot.hasError){
            return Center(child: Text('Error'));
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
            return Center(child: Text('Data not found'));
          }else{
            return ListView(
              children:
                snapshot.data!.docs.map((doc) => buildMessage(doc)).toList()
            );
          }
        });
  }
}
