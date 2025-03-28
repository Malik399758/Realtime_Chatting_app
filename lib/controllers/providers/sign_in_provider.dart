
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInProvider extends ChangeNotifier{

  final signIn = FirebaseAuth.instance;

  Future<User?> userSignIn(String email,String password)async{
    try{
      UserCredential userCredential = await signIn.signInWithEmailAndPassword(email: email, password: password);
      print('User Credential : ------------>${userCredential.credential}');
      if(userCredential.user != null){
        print('Yes User exists ${userCredential.user!.uid}');
        return userCredential.user;
      }else{
        print('User Does not exists');
        return null;
      }
    } on FirebaseException catch(error){
      print('Error : ------------->${error.message}');
      return null;
    }
  }

}