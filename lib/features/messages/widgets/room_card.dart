import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../main.dart';
import '../../../shared/models/user.dart';
import '../models/room.dart';

class RoomCard extends StatelessWidget {
  const RoomCard(this.room, this.user, {super.key});

  final Room room;
  final User user;

  @override
  Widget build(BuildContext context) {
    final chatUser = room.users.where(
      (element) {
        return element.id != user.id;
      },
    ).first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color.fromARGB(20, 0, 0, 0), width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdvancedAvatar(
            name: "room",
            foregroundDecoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(50)),
            statusAlignment: Alignment.topRight,
            image: chatUser.avatar != null
                ? NetworkImage(chatUser.avatar!) // Assuming cardAvatar is a URL
                : null,
            size: 60,
            child: Text(
              user.firstName![0],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${chatUser.firstName} ${chatUser.lastName}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              if (room.lastMessage != null)
                !room.lastMessage!.contains("#image")
                    ? ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          room.lastMessage!,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      )
                    : const Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedImage02,
                            color: Colors.black,
                            size: 24.0,
                          ),
                          Text(" Image ")
                        ],
                      )
            ],
          ),
          const Spacer(),
          Text(format.format(room.lastestMessageDate),
              style: const TextStyle(
                color: Colors.black,
              ))
        ],
      ),
    );
  }
}
