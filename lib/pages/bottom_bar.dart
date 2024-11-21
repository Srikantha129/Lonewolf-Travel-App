import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/explore/explore.dart';
import 'package:lonewolf/pages/home/home.dart';
//import 'package:lonewolf/pages/hotel/hotel_list.dart';
import 'package:lonewolf/pages/profile/profile.dart';
import 'package:lonewolf/pages/trip/trip_home.dart';
import 'package:lonewolf/screens/home_page.dart';


class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int currentIndex = 0;
  DateTime? currentBackPressTime;

  changeIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 80.0,
        child: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getBottomBarItemTile(0, Icons.home),
              getBottomBarItemTile(1, Icons.article),
              getBottomBarItemTile(2, Icons.add_location_sharp),
              getBottomBarItemTile(3, Icons.explore),
              getBottomBarItemTile(4, Icons.person),
            ],
          ),
        ),
      ),
      body: PopScope(
        onPopInvoked: (isExiting) {
          // Check if the user should exit
          if (onWillPop()) {
            exit(0); // Close the app if the user confirms
          }
        },
        child: (currentIndex == 0)
            ? const Homne()
            : (currentIndex == 1)
            ? const HomePage()
            : (currentIndex == 2)
            ? TripHome()
            : (currentIndex == 3)
            ? const Explore()
            : Profile(),
      ),
    );
  }

  getBottomBarItemTile(int index, icon) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.0),
      focusColor: primaryColor,
      onTap: () {
        changeIndex(index);
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color:
          (currentIndex == index) ? Colors.grey[100] : Colors.transparent,
        ),
        child: Icon(icon,
            size: 30.0,
            color: (currentIndex == index) ? primaryColor : greyColor),
      ),
    );
  }

  bool onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'Press Back Once Again to Exit.',
        backgroundColor: Colors.black,
        textColor: whiteColor,
      );
      return false;
    } else {
      return true;
    }
  }
}
