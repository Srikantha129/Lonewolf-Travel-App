import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/trip/trip_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/personalize_route.dart';
import '../../services/journey_db_service.dart';

class TripHome extends StatefulWidget {
  @override
  _TripHomeState createState() => _TripHomeState();
}

class _TripHomeState extends State<TripHome> {
  String? userEmail;
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();

  }
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
      //displayName = prefs.getString('userName');
      print('received userEmail: $userEmail');
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showDeleteDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Delete Current Journey?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'This action is irreversible. Are you sure you want to proceed?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Perform delete action
                await JourneyDbService()
                    .deleteJourneyByEmail(userEmail!);

                // Close dialog and navigate
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const PersonalizeRoute(/*loggedUser: userEmail!*/),
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroundImage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(fixPadding * 1.5),
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.3, 0.6, 0.9],
              colors: [
                whiteColor.withOpacity(0.0),
                whiteColor.withOpacity(0.3),
                whiteColor.withOpacity(0.7),
                whiteColor.withOpacity(1.0),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(fixPadding * 2.0),
                child: Text(
                  'Ready to customize your dream adventure?',
                  style: extraLargeBlackTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                child: Text(
                  'Plan your next unforgettable journey with Lonewolf!',
                  style: greyNormalTextStyle,
                ),
              ),
              heightSpace,
              InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 1000),
                          child: TripMain()));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                  padding: EdgeInsets.all(fixPadding),
                  width: 140.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1.0, color: primaryColor),
                  ),
                  child: Text(
                    'Explore trips',
                    style: primaryColorButtonTextStyle,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () async {
                  bool journeyExists = await JourneyDbService()
                      .isExistsByEmail(userEmail!);
                  print(journeyExists);
                  print(userEmail);

                  if (journeyExists) {
                    _showDeleteDialog();
                  } else {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 1000),
                        child: PersonalizeRoute(/*loggedUser: widget.loggedUser*/),
                      ),
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                  padding: EdgeInsets.all(fixPadding),
                  width: 140.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 1.0, color: primaryColor),
                  ),
                  child: Text(
                    'Explore trips',
                    style: primaryColorButtonTextStyle,
                  ),
                ),
              ),
              heightSpace,
              heightSpace,
            ],
          ),
        ),
      ),
    );

  }
}


/*
void _showDeleteDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Current Journey?'),
      content: const Text('This action is irreversible. Proceed?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await JourneyDbService()
                .deleteJourneyByEmail(widget.loggedUser.email!);
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PersonalizeRoute(loggedUser: widget.loggedUser),
              ),
            );
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}*/
