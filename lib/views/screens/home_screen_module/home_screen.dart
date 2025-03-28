import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_chat_app_firebase/views/components/button_widget.dart';
import 'package:new_chat_app_firebase/views/components/custom_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> updateData(String userId,Map<String,dynamic> newData)async{
    try{
      FirebaseFirestore.instance.collection('chat_app_info').doc(userId).update(newData);
    } catch(e){
      print('error ------->$e');
      throw e;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CustomTextField(hintText: 'name', controller: nameController, textInputType: TextInputType.text),
            SizedBox(height: 20,),
            CustomTextField(hintText: 'email', controller: emailController, textInputType: TextInputType.emailAddress),
            SizedBox(height: 20,),
            CustomTextField(hintText: 'password', controller: passwordController, textInputType: TextInputType.number),
            SizedBox(height: 20,),
            ButtonWidget(text: isLoading ? 'Loading...' : 'Update', color: Colors.black87, voidCallback: ()async{
              setState(() {
                setState(() {
                  isLoading = false;
                });
              });
              try{
                User? user = FirebaseAuth.instance.currentUser;
                if(user != null){
                  String? userId = user.uid;
                  await updateData(
                      userId,{
                    'user name' : nameController.text,
                    'password' : passwordController.text,
                    'email' : emailController.text
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: SnackBar(content: Text('Data updated'))));
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: SnackBar(content: Text('user not logged in '))));
                }

                setState(() {
                 isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: SnackBar(content: Text('Data updated'))));
              } catch(error){
                print('error ---->$error');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: SnackBar(content: Text('Data not updated'))));
                setState(() {
                  isLoading = false;
                });
              }

            })
          ],
        ),
      )
    );
  }
}
