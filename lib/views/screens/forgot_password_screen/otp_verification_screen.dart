import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_chat_app_firebase/views/components/button_widget.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final optController = TextEditingController();
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
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 15.sp,),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              Text('OTP Verification',style: GoogleFonts.poppins(fontSize: 26.sp,fontWeight: FontWeight.w600),),
              SizedBox(height: 10.h,),
              Text('Please check your email www.uihut@gmail.com to see the verification code',style: GoogleFonts.poppins(fontSize: 16.sp,fontWeight: FontWeight.w400,color: Colors.grey),
              textAlign: TextAlign.center,),
              SizedBox(height: 30.h,),
              Container(
                width: 335.w,
                height: 228.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('OTP Code',style: GoogleFonts.poppins(fontSize: 20.sp,fontWeight: FontWeight.w600),),
                    SizedBox(height: 20.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                     /*   Container(
                          width: 70.w,
                          height: 56.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade200
                          ),
                        ),
                        Container(
                          width: 70.w,
                          height: 56.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade200
                          ),
                        ),
                        Container(
                          width: 70.w,
                          height: 56.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade200
                          ),
                        ),
                        Container(
                          width: 70.w,
                          height: 56.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade200
                          ),
                        ),*/
                        OtpReuseCode(hintText: '.', textInputType: TextInputType.number, controller:optController ),
                        OtpReuseCode(hintText: '.', textInputType: TextInputType.number, controller:optController ),
                        OtpReuseCode(hintText: '.', textInputType: TextInputType.number, controller:optController ),
                        OtpReuseCode(hintText: '.', textInputType: TextInputType.number, controller:optController )
                      ],
                    ),
                    SizedBox(height: 30.h,),
                    ButtonWidget(text: 'Verify', color: Colors.black87, voidCallback: (){}),
                    SizedBox(height: 20.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Resend code to',style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400),),
                        Text('01:26',style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w400),)
                      ],
                    )
                  ],
                ),
              )
          
            ],
          ),
        ),
      ),
    );
  }
}
class OtpReuseCode extends StatelessWidget {
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController controller;
  const OtpReuseCode({super.key,required this.hintText,required this.textInputType,required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderSide: BorderSide.none
          ),
        ),
      ),
    );
  }
}

