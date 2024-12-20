import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';

import 'features/favorites/favorites.dart';
import 'features/messages/message.dart';
import 'features/profile/profile.dart';
import 'features/travel/travel.dart';
import 'features/trips/trip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavigationIndex = 0;

  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const Travel(),
    const Favorites(),
    const Trip(),
    const Message(),
    const Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _bottomNavigationIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavigationIndex,
        onTap: (value) {
          setState(() {
            _bottomNavigationIndex = value;
          });
          _pageController.jumpToPage(value);
        },
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: Colors.red,
              size: 25.0,
            ),
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: Colors.black,
              size: 25.0,
            ),
            label: "Travel",
          ),
          const BottomNavigationBarItem(
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedFavourite,
              color: Colors.red,
              size: 25.0,
            ),
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedFavourite,
              color: Colors.black,
              size: 25.0,
            ),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              "assets/images/logo.svg",
              height: 25.0,
              color: Colors.red,
            ),
            icon: SvgPicture.asset(
              "assets/images/logo.svg",
              height: 25.0,
            ),
            label: "Trips",
          ),
          const BottomNavigationBarItem(
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedBubbleChat,
              color: Colors.red,
              size: 25.0,
            ),
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedBubbleChat,
              color: Colors.black,
              size: 25.0,
            ),
            label: "Message",
          ),
          const BottomNavigationBarItem(
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedUserCircle,
              color: Colors.red,
              size: 25.0,
            ),
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedUserCircle,
              color: Colors.black,
              size: 25.0,
            ),
            label: "Profile",
          )
        ],
      ),
    );
  }
}
