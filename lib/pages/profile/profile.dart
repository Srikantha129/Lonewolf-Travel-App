import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lonewolf/screens/login_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/invite_friend/invite_friend.dart';
import 'package:lonewolf/pages/login_signup/login.dart';
import 'package:lonewolf/pages/notifications/notifications.dart';
import 'package:lonewolf/pages/profile/edit_profile.dart';
import 'package:lonewolf/pages/wallet/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/support.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? photoURL;
  String? displayName;
  String? userId;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      photoURL = prefs.getString('userPhoto');
      displayName = prefs.getString('userName');
      userId = prefs.getString('userId');
      debugPrint('received photoUrl: $photoURL');
      debugPrint('received userId: $userId');
    });
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    logoutDialogue() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // Return object of type Dialog
          return Dialog(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              height: 135.0,
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "You sure want to logout?",
                    style: blackBigTextStyle,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Cancel',
                            style: blackColorButtonTextStyle,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          // Remove user email from SharedPreferences
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.remove('userEmail');

                          // Sign out the user
                          await FirebaseAuth.instance.signOut();

                          // Navigate to Login page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        child: Container(
                          width: (width / 3.5),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            'Log out',
                            style: whiteColorButtonTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }


    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        elevation: 0.0,
        title: Text(
          'Profile',
          style: blackHeadingTextStyle,
        ),
      ),
      body: ListView(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: EditProfile()));
            },
            child: Container(
              padding: EdgeInsets.all(fixPadding * 2.0),
              color: whiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          image: DecorationImage(
                            image: photoURL != null && photoURL!.isNotEmpty
                                ? NetworkImage(photoURL!)
                                : const AssetImage('assets/user1.jpg') as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      widthSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            displayName ?? 'User',
                            style: blackBigTextStyle,
                          ),
                          heightSpace,
                          Text(
                            'Welcome Back,',
                            style: greySmallTextStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.0,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(fixPadding),
            padding: EdgeInsets.all(fixPadding),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 1.5,
                  spreadRadius: 1.5,
                  color: Colors.grey[200]!,
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: Notifications()));
                  },
                  child: getTile(
                      Icon(Icons.notifications,
                          color: Colors.grey.withOpacity(0.6)),
                      'Notifications'),
                ),
                /*InkWell(
                  onTap: () {},
                  child: getTile(
                      Icon(Icons.language, color: Colors.grey.withOpacity(0.6)),
                      'Language'),
                ),*/
                InkWell(
                  onTap: () {},
                  child: getTile(
                      Icon(Icons.settings, color: Colors.grey.withOpacity(0.6)),
                      'Settings'),
                ),
                /*InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            duration: Duration(milliseconds: 400),
                            type: PageTransitionType.rightToLeft,
                            child: InviteFriend()));
                  },
                  child: getTile(
                      Icon(Icons.group_add,
                          color: Colors.grey.withOpacity(0.6)),
                      'Invite Friends'),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            duration: Duration(milliseconds: 400),
                            type: PageTransitionType.rightToLeft,
                            child: Wallet()));
                  },
                  child: getTile(
                      Icon(Icons.account_balance_wallet,
                          color: Colors.grey.withOpacity(0.6)),
                      'Lonewolf Cash'),
                ),*/
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SupportPage()),
                    );
                  },
                  child: getTile(
                      Icon(Icons.headset_mic,
                          color: Colors.grey.withOpacity(0.6)),
                      'Support'),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(fixPadding),
            padding: EdgeInsets.all(fixPadding),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 1.5,
                  spreadRadius: 1.5,
                  color: Colors.grey[200]!,
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: logoutDialogue,
                  child: getTile(
                      Icon(Icons.exit_to_app,
                          color: Colors.grey.withOpacity(0.6)),
                      'Logout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getTile(Icon icon, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              child: icon,
            ),
            widthSpace,
            Text(
              title,
              style: blackSmallTextStyle,
            ),
          ],
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 16.0,
          color: Colors.grey.withOpacity(0.6),
        ),
      ],
    );
  }
}
