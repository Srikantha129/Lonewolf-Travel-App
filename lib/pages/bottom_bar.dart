/*
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/explore/explore.dart';
import 'package:lonewolf/pages/home/home.dart';
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
              getBottomBarItemTile(0, Icons.home, 'Home'),
              getBottomBarItemTile(1, Icons.article, 'Blog'),
              getBottomBarItemTile(2, Icons.add_location_sharp, 'Trips'),
              getBottomBarItemTile(3, Icons.explore, 'Explore'),
              getBottomBarItemTile(4, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          // Check if the user should exit
          if (onWillPop()) {
            exit(0); // Close the app if the user confirms
          }
          return false;
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

  getBottomBarItemTile(int index, IconData icon, String label) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.0),
      focusColor: primaryColor,
      onTap: () {
        changeIndex(index);
      },
      child: Container(
        height: 80.0,
        width: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color:
          (currentIndex == index) ? Colors.grey[100] : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30.0,
              color: (currentIndex == index) ? primaryColor : greyColor,
            ),
            const SizedBox(height: 5.0), // Add some spacing between icon and label
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                color: (currentIndex == index) ? primaryColor : greyColor,
              ),
            ),
          ],
        ),
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
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lonewolf/pages/explore/explore.dart'; // Explore page
import 'package:lonewolf/pages/home/home.dart'; // Home page
import 'package:lonewolf/pages/profile/profile.dart'; // Profile page
import 'package:lonewolf/pages/trip/trip_home.dart'; // Trip page
import 'package:lonewolf/screens/home_page.dart'; // Blog page

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
          notchMargin: 10.0,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              getBottomBarItemTile(0, Icons.home, 'Home'),
              getBottomBarItemTile(1, Icons.article, 'Blog'),
              const SizedBox(width: 40), // Space for the elevated Trip tab
              getBottomBarItemTile(3, Icons.explore, 'Explore'),
              getBottomBarItemTile(4, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue, // Change color to blue
        onPressed: () {
          changeIndex(2);
        },
        shape: const CircleBorder(), // Make it circular
        elevation: 10.0, // Add shadow effect
        child: const Icon(Icons.add_location_sharp, size: 30.0), // Define shadow color and opacity
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: getBody(currentIndex), // Dynamic content rendering
    );
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return const Homne(); // Replace with actual Home page
      case 1:
        return const HomePage(); // Blog page
      case 2:
        return TripHome(); // Trip page
      case 3:
        return const Explore(); // Explore page
      case 4:
        return Profile(); // Profile page
      default:
        return const Center(child: Text("Page not found!"));
    }
  }

  getBottomBarItemTile(int index, IconData icon, String label) {
    bool isHighlighted = index == 2; // Highlight Trip tab
    return InkWell(
      borderRadius: BorderRadius.circular(30.0),
      onTap: () {
        changeIndex(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: isHighlighted ? 40.0 : 30.0, // Larger size for "Trip"
            color: isHighlighted
                ? Colors.orange
                : (currentIndex == index)
                ? Colors.blue
                : Colors.grey,
          ),
          const SizedBox(height: 5.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted
                  ? Colors.orange
                  : (currentIndex == index)
                  ? Colors.blue
                  : Colors.grey,
            ),
          ),
        ],
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
        textColor: Colors.white,
      );
      return false;
    } else {
      return true;
    }
  }
}
