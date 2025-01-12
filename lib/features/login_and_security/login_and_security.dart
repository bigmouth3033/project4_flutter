import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project4_flutter/features/login_and_security/widgets/change_password.dart';

class LoginAndSecurity extends StatefulWidget {
  const LoginAndSecurity({super.key});

  @override
  State<LoginAndSecurity> createState() => _LoginAndSecurityState();
}

class _LoginAndSecurityState extends State<LoginAndSecurity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login and Security")),
      body: Column(
        children: [
          Row(
            children: [
              ChangePassword()
            ],
          )
        ],
      ),
    );
  }
}
