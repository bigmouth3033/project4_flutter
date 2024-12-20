import 'package:flutter/material.dart';
import 'package:project4_flutter/features/authentication/api/authentication_api.dart';
import 'package:project4_flutter/features/authentication/widget/user_login.dart';
import 'package:project4_flutter/features/authentication/widget/user_register.dart';
import 'package:project4_flutter/shared/models/custom_result.dart';
import 'package:project4_flutter/shared/widgets/custom_input_form.dart';
import 'package:project4_flutter/shared/widgets/red_button.dart';

class Authentication extends StatefulWidget {
  Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  final AuthenticationApi authenticationApi = AuthenticationApi();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null; // Return null if the input is valid
  }

  void checkAccountExist() async {
    if (_formKey.currentState!.validate()) {
      var body = <String, String>{};

      body['email'] = _emailController.value.text;

      CustomResult customResult =
          await authenticationApi.authenticationRequest(body);

      if (customResult.data as bool == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Navigate to login")),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserLogin(_emailController.value.text)),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Navigate to sign-up")),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    UserRegister(_emailController.value.text)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize:
              const Size.fromHeight(1.0), // Set the height of the border
          child: Container(
            color: const Color.fromARGB(30, 0, 0, 0), // Border color
            height: 1.0, // Border thickness
          ),
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Log in or sign up to Urban Nest",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomInputForm(
                    isPassword: false,
                    inputController: _emailController,
                    validation: validateEmail,
                    labelText: "Email",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RedButton(action: checkAccountExist, text: "Continue"),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Color.fromARGB(30, 0, 0, 0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("or"),
                ),
                Expanded(
                  child: Divider(
                    color: Color.fromARGB(30, 0, 0, 0),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  minimumSize: const Size.fromHeight(55)),
              child: const Text(
                "Continue with Google",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}
