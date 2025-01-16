import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project4_flutter/features/login_and_security/models/change_password_request.dart';
import 'package:project4_flutter/features/login_and_security/models/otp_confirm_request.dart';
import 'package:project4_flutter/features/personal_information/service/personal_information_service.dart';
import 'package:project4_flutter/features/personal_information/service/validator_service.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController =
      TextEditingController(text: "");
  TextEditingController newPasswordController = TextEditingController(text: "");
  TextEditingController confirmPasswordController =
      TextEditingController(text: "");
  PersonalInformationService _personalInformationService =
      new PersonalInformationService();
  bool isShowOtp = false;
  String otpConfirm = "";

  void handlePutChangePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        ChangePasswordRequest changePasswordRequest = ChangePasswordRequest(
            currentPassword: currentPasswordController.text,
            newPassword: newPasswordController.text,
            confirmPassword: confirmPasswordController.text);

        await _personalInformationService
            .putChangePassword(changePasswordRequest);

        setState(() {
          isShowOtp = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Otp sent to your email")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update Password: $e")),
        );
      }
    }
  }

  void handleCheckOtp() async {
    try {
      OtpConfirmRequest otpConfirmRequest = OtpConfirmRequest(Otp: otpConfirm);
      await _personalInformationService.putCheckOtp(otpConfirmRequest);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Update password successful")),
      );
      setState(() {
        isShowOtp = false;
        currentPasswordController.text = "";
        newPasswordController.text = "";
        confirmPasswordController.text = "";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update Password: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Change Password",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(child: Container()),
              Container(
                child: TextButton(onPressed: () {}, child: Text("Update")),
              )
            ],
          ),
          isShowOtp
              ? Container(
                  child: Column(children: [
                    OtpTextField(
                      numberOfFields: 4,
                      borderColor: Color(0xFF512DA8),
                      //set to true to show as box or false to show as dash
                      showFieldAsBox: true,
                      //runs when a code is typed in
                      onCodeChanged: (String code) {
                        //handle validation or checks here
                      },
                      //runs when every textfield is filled
                      onSubmit: (String verificationCode) {
                        otpConfirm = verificationCode;

                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return AlertDialog(
                        //         title: Text("Verification Code"),
                        //         content:
                        //             Text('Code entered is $verificationCode'),
                        //       );
                        //     });
                      }, // end onSubmit
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isShowOtp = false;
                                currentPasswordController.text = "";
                                newPasswordController.text = "";
                                confirmPasswordController.text = "";
                              });
                            },
                            child: Text("Cancel")),
                        Expanded(child: Container()),
                        ElevatedButton(
                            onPressed: () => handleCheckOtp(),
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ))
                      ],
                    )
                  ]),
                )
              : Container(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Current Password",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              TextFormField(
                                controller: currentPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2)),
                                  // label: Text(
                                  //   "Current",
                                  //   style: TextStyle(color: Colors.black),
                                  // ),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  return Validator.validatePassword(
                                      value, "Current Password");
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("New Password",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              TextFormField(
                                controller: newPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2)),
                                  // label: Text(
                                  //   "Current",
                                  //   style: TextStyle(color: Colors.black),
                                  // ),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  return Validator.validatePassword(
                                      value, "New password");
                                },
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Corfirm Password",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              TextFormField(
                                controller: confirmPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 2)),
                                  // label: Text(
                                  //   "Current",
                                  //   style: TextStyle(color: Colors.black),
                                  // ),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  return Validator.validatePassword(
                                      value, "Confirm password");
                                },
                              )
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () => handlePutChangePassword(),
                              child: Text(
                                "Save",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ))
                        ],
                      )),
                )
        ],
      ),
    );
  }
}
