import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/features/profile/widgets/authorize_profile.dart';
import 'package:project4_flutter/features/profile/widgets/unauthorize_profile.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_cubit.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_state.dart';

import '../../home_screen.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserNotLogin) {
          return const UnauthorizeProfile();
        }

        if (state is UserLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is UserSuccess) {
          return const AuthorizeProfile();
        }

        return const Text("Loading....");
      },
      listener: (context, state) {
        if (state is UserError) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false, // Removes all previous routes
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
    );
  }
}
// Consumer<UserProvider>(
// builder: (context, userProvider, child) {
// if (userProvider.isLoading) {
// return const Center(child: CircularProgressIndicator());
// } else if (userProvider.user != null) {
// return const AuthorizeProfile();
// } else {
// return const UnauthorizeProfile();
// }
// },
// )
