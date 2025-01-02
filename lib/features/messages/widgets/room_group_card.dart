import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../../../shared/models/user.dart';
import '../models/room.dart';

final format = DateFormat.yMd();

class RoomGroupCard extends StatelessWidget {
  const RoomGroupCard(this.room, this.user, {super.key});

  final Room room;
  final User user;

  @override
  Widget build(BuildContext context) {
    final chatUser = room.users;

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
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                childAspectRatio:
                    1.0, // Maintain square aspect ratio for each grid item
              ),
              itemCount: chatUser.length > 4 ? 4 : chatUser.length,
              itemBuilder: (context, index) {
                return Center(
                  child: AdvancedAvatar(
                    name: "room",
                    foregroundDecoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    statusAlignment: Alignment.topRight,
                    image: chatUser[index].avatar != null
                        ? NetworkImage(chatUser[index].avatar!)
                        : null,
                    size: 30,
                    child: Text(
                      user.firstName![0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${room.name}",
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
                          room.lastMessage!,
                          overflow: TextOverflow.ellipsis,
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
