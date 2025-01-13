import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project4_flutter/features/user_profile/widgets/user_avatar.dart';
import 'package:project4_flutter/features/user_profile/widgets/user_refill.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight - appBarHeight-statusBarHeight,
        color: Colors.grey[200],
        child: Column(
          children: [
            UserAvatar(),
            UserRefill()
          ],
        ),
      ),
    );
  }
}
