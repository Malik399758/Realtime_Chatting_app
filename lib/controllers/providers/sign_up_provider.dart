
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier{

  final fireBaseStore = FirebaseFirestore.instance;
  Future<void> userSignUpDetail(String userId,String userName,String email,String password,String imageUrl)async{
    try{
      fireBaseStore.collection('chat_app_info').doc(userId).set({
        'uid' : userId,
        'user name' : userName,
        'email' : email,
        'password' : password,
        'imageUrl' : imageUrl,
      });
    } on FirebaseException catch(error){
      print('Error : ---------->${error.message}');
    }

  }
}