import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonWidget extends StatefulWidget {
  final String text;
  final Color color;
  final VoidCallback voidCallback;
  const ButtonWidget({super.key,required this.text,required this.color,required this.voidCallback});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.voidCallback,
      child: Container(
        width: 335,
        height: 56,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: Text(widget.text,style: GoogleFonts.poppins(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),)),
      ),
    );
  }
}
