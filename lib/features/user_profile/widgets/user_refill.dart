import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserRefill extends StatefulWidget {
  const UserRefill({super.key});

  @override
  State<UserRefill> createState() => _UserRefillState();
}

class _UserRefillState extends State<UserRefill> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth/1.2,
      decoration: BoxDecoration(
          color: Colors.white, // Specify the background color here
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2), // Màu bóng
              spreadRadius: 2, // Độ lan tỏa
              blurRadius: 5, // Độ mờ của bóng
              offset: Offset(0, 3), // Vị trí của bóng
            )
          ]
      ),
      child: Column(
        children: [
          Text("Banh bao's refilled Information", style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
          Text("Phone Number"),
          Text("Real Avatar")
        ],
      ),
    );
  }
}
