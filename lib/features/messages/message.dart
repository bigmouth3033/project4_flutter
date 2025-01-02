import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:project4_flutter/app.dart';
import 'package:project4_flutter/features/messages/bloc/message_cubit/message_cubit.dart';
import 'package:project4_flutter/features/messages/bloc/message_cubit/message_room_cubit.dart';
import 'package:project4_flutter/features/messages/widgets/messages_body.dart';
import 'package:project4_flutter/shared/widgets/loading_icon.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../shared/bloc/user_cubit/user_cubit.dart';
import '../../shared/bloc/user_cubit/user_state.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserSuccess) {
          final user = state.user;
          return BlocProvider(
            create: (_) => MessageRoomCubit(user.id.toString()),
            child: const MessagesBody(),
          );
        }

        if (state is UserLoading) {
          return const LoadingIcon(size: 50);
        }

        if (state is UserNotLogin) {
          return const Center(
              child: Text("Please login to access chat feature"));
        }
        return const Text("Loading...");
      },
    );
  }
}
