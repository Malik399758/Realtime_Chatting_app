import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('App Bar'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          SizedBox(height: 20,),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: ()async{
              setState(() {
                isLoading = true;
              });
              try{
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully')));
                setState(() {
                  isLoading = false;
                });
              }catch(e){
                print('Error ------->$e');
                setState(() {
                  isLoading = false;
                });
              }
            },
            child: Container(
              width: 200,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CupertinoColors.black
              ),
              child: isLoading ? Center(child: CircularProgressIndicator(
                color: Colors.white,
              )) : Center(child: Text('Sign Up',style: GoogleFonts.poppins(fontSize: 20,color: Colors.white),)),
            ),
          )
        ],
      ),
    );
  }
}
