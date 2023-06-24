import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {

  String? message;

  ProgressDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFff725e),
      child: Container(
        margin: const EdgeInsets.all(7.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [

              const SizedBox(width: 6.0,),

              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFff725e)),
              ),

              const SizedBox(width: 26.0,),
              
              Text(
                message!,
                style: const TextStyle(
                  color: Color(0xFFff725e),
                  fontSize: 15.0,
                ),
              )

            ],
          ),
        )
      ),
    );
  }
}
