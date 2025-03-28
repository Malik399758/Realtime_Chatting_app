import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:new_chat_app_firebase/views/screens/auth_module/sign_up_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  Color blackColor = Colors.black;
  final pageController = PageController();

  int currentIndex = 0;

  void Current(int index){
    setState(() {
      currentIndex = index;
    });
  }

  List onBoardingList = [
    {
      'image' : 'assets/images/Animation - 1741975041697.json',
      'description' : 'Find and connect with people easily.\n'
      'Start meaningful conversations anytime,\n     anywhere!',
    },
    {
      'image' : 'assets/images/Animation - 1741975269723.json',
      'description' : 'Your chats are encrypted and safe. Enjoy seamless communication with complete privacy!',
    },
    {
      'image' : 'assets/images/Animation - 1741951494828.json',
      'description' : 'Send messages, emojis, and media effortlessly. Make every chat fun and engaging!',
    },

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: Text('Skip',style: GoogleFonts.poppins(color: blackColor,fontSize: 16),))
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: onBoardingList.length,
              onPageChanged: Current,
              controller: pageController,
              itemBuilder: (context,index){
                return Column(
                  children: [
                    Lottie.asset(onBoardingList[index]['image'],height: 400),
                    SizedBox(height: 40,),
                    Center(child: Text(onBoardingList[index]['description'],style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w400),textAlign: TextAlign.center,)),
                    SizedBox(height: 40,),
                    SmoothPageIndicator(
                        effect: SwapEffect(),
                        onDotClicked:(index){
                          pageController.animateToPage(index, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
                        },
                        controller: pageController, count: onBoardingList.length),
                    SizedBox(height: 50,),
                    Container(
                      width: 335,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: CupertinoColors.black,
                      ),
                      child: currentIndex == 0 ? Center(child: Text('Get Started',style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.white),)) :
                      Center(child: GestureDetector(
                        onTap : (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                          child: Text('Next',style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.white),))),)
                  ],
                );

          }),
        ],
      ),
    );
  }
}
