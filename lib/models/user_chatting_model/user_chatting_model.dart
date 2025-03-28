// User chatting model


import 'package:cloud_firestore/cloud_firestore.dart';

class UserChattingModel{
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String senderName;



  UserChattingModel({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.senderName,
});

  Map<String,dynamic> toMap(){
    return {
      'senderId' : senderId,
      'senderEmail' : senderEmail,
      'receiverId' : receiverId,
      'message' : message,
      'timestamp' : timestamp,
      'senderName': senderName
    };
  }




}