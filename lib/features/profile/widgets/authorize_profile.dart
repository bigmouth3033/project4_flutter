import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:project4_flutter/main.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_cubit.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_state.dart';

class AuthorizeProfile extends StatelessWidget {
  const AuthorizeProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserSuccess) {
          var user = state.user;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Profile",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              toolbarHeight: 50,
              actions: const [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedNotification03,
                  color: Colors.black,
                  size: 24.0,
                )
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        padding:
                            const EdgeInsetsDirectional.symmetric(vertical: 20),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(50, 0, 0, 0),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AdvancedAvatar(
                              name: "user name",
                              statusColor: Colors.green,
                              statusAlignment: Alignment.topRight,
                              size: 60,
                              child: Text(
                                user.firstName![0],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${user.firstName}",
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.all(0)),
                                  onPressed: () {},
                                  child: const Text("Show profile"),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowRight01,
                              color: Colors.black,
                              size: 24.0,
                            )
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero, // No rounded corners, sharp rectangle edges
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(30, 0, 0, 0), width: 1),
                            ),
                          ),
                          child: const Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedUserCircle,
                                color: Colors.black,
                                size: 26.0,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Personal information",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Spacer(),
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowRight01,
                                color: Colors.black,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero, // No rounded corners, sharp rectangle edges
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(30, 0, 0, 0), width: 1),
                            ),
                          ),
                          child: const Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedShield01,
                                color: Colors.black,
                                size: 26.0,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Login & security",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Spacer(),
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowRight01,
                                color: Colors.black,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero, // No rounded corners, sharp rectangle edges
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(30, 0, 0, 0), width: 1),
                            ),
                          ),
                          child: const Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedMoney03,
                                color: Colors.black,
                                size: 26.0,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Payment and payouts",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Spacer(),
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowRight01,
                                color: Colors.black,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero, // No rounded corners, sharp rectangle edges
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(30, 0, 0, 0), width: 1),
                            ),
                          ),
                          child: const Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedNotification02,
                                color: Colors.black,
                                size: 26.0,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Notifications",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Spacer(),
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowRight01,
                                color: Colors.black,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero, // No rounded corners, sharp rectangle edges
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(30, 0, 0, 0), width: 1),
                            ),
                          ),
                          child: const Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedBackpack03,
                                color: Colors.black,
                                size: 26.0,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Travel",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Spacer(),
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowRight01,
                                color: Colors.black,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Legal",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero, // No rounded corners, sharp rectangle edges
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(30, 0, 0, 0), width: 1),
                            ),
                          ),
                          child: const Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedBookOpen02,
                                color: Colors.black,
                                size: 26.0,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Term of Service",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Spacer(),
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowRight01,
                                color: Colors.black,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero, // No rounded corners, sharp rectangle edges
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(30, 0, 0, 0), width: 1),
                            ),
                          ),
                          child: const Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedBookOpen02,
                                color: Colors.black,
                                size: 26.0,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Term of Service",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Spacer(),
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowRight01,
                                color: Colors.black,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero, // No rounded corners, sharp rectangle edges
                        ),
                      ),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromARGB(30, 0, 0, 0), width: 1),
                            ),
                          ),
                          child: const Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedBookOpen02,
                                color: Colors.black,
                                size: 26.0,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Open source licenses",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Spacer(),
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedArrowRight01,
                                color: Colors.black,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                        onPressed: () {
                          Map<String, dynamic> body = {
                            'token': fcmToken,
                            'userId': user.id
                          };
                          context.read<UserCubit>().logout(body);
                        },
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0)),
                        child: const Text(
                          "Log out",
                          style: TextStyle(
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Text("Loading....");
      },
    );
  }
}
