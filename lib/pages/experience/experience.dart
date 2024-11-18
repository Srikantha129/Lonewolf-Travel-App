import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/experience/selectDate.dart';
import 'package:lonewolf/widget/carousel_pro/lib/carousel_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/popular_experiences.dart';
//import 'package:lonewolf/p';

class Experience extends StatefulWidget {
  final PopularExperience experience;
  const Experience({super.key, required this.experience,});
  @override
  ExperienceState createState() => ExperienceState();
}

class ExperienceState extends State<Experience> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Set<Marker> markers = <Marker>{};
  double _averageRating = 0.0;
  double _userRating = 0.0;
  String? userId;
  String? userName;
  final List<int> _ratingsDistribution = List.filled(5, 0);

  @override
  void initState() {
    super.initState();
    _fetchAverageRating();
    _getUserInfo();
    //markers = Set.from([]);
  }





  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      userName = prefs.getString('userName');
    });
  }

  Future<void> _fetchAverageRating() async {
    final ratingsSnapshot = await _firestore
        .collection('popular_experiences')
        .doc(widget.experience.name)
        .collection('ratings')
        .get();

    if (ratingsSnapshot.docs.isNotEmpty) {
      final ratings = ratingsSnapshot.docs.map((doc) => doc['rating'] as double).toList();
      setState(() {
        _averageRating = ratings.reduce((a, b) => a + b) / ratings.length;
        _ratingsDistribution.fillRange(0, 5, 0); // Reset distribution

        for (var rating in ratings) {
          _ratingsDistribution[5 - rating.toInt()] += 1;
        }
      });
    }
  }

  Future<void> _submitRating(double rating) async {
    try {
      await _firestore
          .collection('popular_experiences')
          .doc(widget.experience.name)
          .collection('ratings')
          .doc(userId)
          .set({'userId': userId, 'rating': rating});

      _fetchAverageRating();
    } catch (e) {
      print('Error submitting rating: $e');
    }
  }

  //////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        title: Text(widget.experience.name, style: appBarTextStyle),
      ),
      bottomNavigationBar: Material(
        elevation: 5.0,
        child: Container(
          color: Colors.white,
          width: width,
          height: 70.0,
          padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'From \$ ${widget.experience.price}',
                    style: blackBigBoldTextStyle,
                  ),
                  Text(
                    ' / person',
                    style: blackSmallTextStyle,
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: SelectDate()));
                },
                child: Container(
                  padding: EdgeInsets.only(
                      top: fixPadding,
                      bottom: fixPadding,
                      right: fixPadding * 2.0,
                      left: fixPadding * 2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: primaryColor,
                  ),
                  child: Text(
                    'Book now',
                    style: whiteColorButtonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          // Slider Start
          slider(),
          // Slider End
          // Name Rating Start
          nameRating(),
          // Name Rating End
          divider(),
          // Hosted by Start
          hostedBy(),
          // Hosted by End
          divider(),
          // What you do Start
          whatYouDo(),
          // What you do End
          divider(),
          // What included Start
          whatIncluded(),
          // What included End
          divider(),
          // Meet your host Start
          meetYourHost(),
          // Meet your host End
          divider(),
          // Where you will be Start
          whereYouWillBwe(),
          // Where you will be End
          divider(),
          _buildRatingSection()
        ],
      ),
    );
  }

  slider() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Access images from the experience object
    List<String> images = widget.experience.images;

    return SizedBox(
      height: height / 1.6,
      width: width,
      child: Carousel(
        images: images.map((imagePath) {
          return Builder(
            builder: (context) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  imagePath, // Tries to load as AssetImage first
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to base64 decoding if AssetImage fails
                    try {
                      return Image.memory(
                        base64Decode(imagePath),
                        fit: BoxFit.cover,
                      );
                    } catch (e) {
                      // If base64 also fails, display an error icon
                      return Icon(Icons.broken_image, size: 50, color: Colors.red);
                    }
                  },
                ),
              );
            },
          );
        }).toList(),
        dotSize: 6.0,
        dotSpacing: 18.0,
        dotColor: primaryColor,
        indicatorBgPadding: 5.0,
        dotBgColor: Colors.transparent,
        borderRadius: false,
        moveIndicatorFromBottom: 180.0,
        noRadiusForIndicator: true,
        overlayShadow: true,
        overlayShadowColors: Colors.white,
        overlayShadowSize: 0.7,
      ),
    );
  }


  divider() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 1.0,
      color: greyColor.withOpacity(0.2),
      margin: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
    );
  }

  nameRating() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.experience.name,
            style: blackHeadingTextStyle,
          ),
          heightSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.lime[600], size: 18.0),
              SizedBox(width: 3.0),
              Text(_averageRating.toStringAsFixed(1), style: greySmallTextStyle),
            ],
          ),
        ],
      ),
    );
  }

  hostedBy() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Experience hosted by ${widget.experience.hostName.split(' ').first}',
                style: blackBigBoldTextStyle
              ),
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  image: DecorationImage(
                    image: AssetImage('assets/host.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          heightSpace,
          experienceInfoTile('assets/icons/clock.png', '${widget.experience.duration} mins'),
          heightSpace,
          experienceInfoTile('assets/icons/tag.png', 'Includes equipment'),
          heightSpace,
          experienceInfoTile('assets/icons/group.png', 'Up to ${widget.experience.maxPeople} people'),
          heightSpace,
          experienceInfoTile('assets/icons/chat.png', 'Hosted in ${widget.experience.languages.join(', ')}')
          ,
        ],
      ),
    );
  }

  experienceInfoTile(imagePath, title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(imagePath,
            width: 30.0, height: 30.0, fit: BoxFit.fitHeight),
        widthSpace,
        Text(title, style: blackNormalTextStyle),
      ],
    );
  }

  whatYouDo() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What you\'ll do', style: blackBigBoldTextStyle),
          heightSpace,
          Text(
            widget.experience.description,
            style: greySmallTextStyle,
            textAlign: TextAlign.justify,
          ),

        ],
      ),
    );
  }

  whatIncluded() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What\'s included', style: blackBigBoldTextStyle),
          heightSpace,
          Container(
            padding: EdgeInsets.all(fixPadding * 2.0),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                  color: Colors.grey[300]!,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/icons/travel.png',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.fitHeight,
                ),
                heightSpace,
                Text(
                  'Equipment',
                  style: blackBigBoldTextStyle,
                ),
                heightSpace,
                Text(
                  'Photo Equipment - special lenses.',
                  style: blackNormalTextStyle,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

/*  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blueAccent.withOpacity(0.2), Colors.white],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Average Rating:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Text(_averageRating.toStringAsFixed(1), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(width: 5),
              const Icon(Icons.star, color: Colors.blue, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: List.generate(5, (index) {
              final stars = 5 - index;
              final progress = _ratingsDistribution[index] / (_ratingsDistribution.reduce((a, b) => a + b) + 1e-9); // Avoid divide by zero
              return Row(
                children: [
                  Text("$stars stars", style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 10),
                  Expanded(child: LinearProgressIndicator(value: progress, color: Colors.blue, backgroundColor: Colors.blue.shade100)),
                  const SizedBox(width: 5),
                  Text(_ratingsDistribution[index].toString(), style: const TextStyle(fontSize: 14)),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),
          const Text('Rate this Post:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          RatingBar.builder(
            initialRating: _userRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) => _submitRating(rating),
          ),
        ],
      ),
    );
  }*/

  Widget _buildRatingSection() {
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding
      child: Container(
        padding: const EdgeInsets.all(16.0), // Add padding to the content
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blueAccent.withOpacity(0.2), Colors.white],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Average Rating:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text(_averageRating.toStringAsFixed(1), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(width: 5),
                const Icon(Icons.star, color: Colors.blue, size: 20),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(5, (index) {
                final stars = 5 - index;
                final progress = _ratingsDistribution[index] / (_ratingsDistribution.reduce((a, b) => a + b) + 1e-9); // Avoid divide by zero
                return Row(
                  children: [
                    Text("$stars stars", style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 10),
                    Expanded(child: LinearProgressIndicator(value: progress, color: Colors.blue, backgroundColor: Colors.blue.shade100)),
                    const SizedBox(width: 5),
                    Text(_ratingsDistribution[index].toString(), style: const TextStyle(fontSize: 14)),
                  ],
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text('Rate this Post:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: _userRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) => _submitRating(rating),
            ),
          ],
        ),
      ),
    );
  }



  meetYourHost() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35.0),
                  image: DecorationImage(
                    image: AssetImage('assets/host.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              widthSpace,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meet your host, Peter',
                    style: blackBigBoldTextStyle,
                  ),
                  heightSpace,
                  Text(
                    'Host on TravelPro since 2018',
                    style: greySmallTextStyle,
                  ),
                ],
              ),
            ],
          ),
          heightSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.lime[600], size: 18.0),
              SizedBox(width: 5.0),
              Text('208 Reviews', style: greySmallTextStyle),
              widthSpace,
              widthSpace,
              Icon(Icons.verified_user, color: Colors.lime[600], size: 18.0),
              SizedBox(width: 5.0),
              Text('Identity verified', style: greySmallTextStyle),
            ],
          ),
          heightSpace,
          Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
            style: greySmallTextStyle,
            textAlign: TextAlign.justify,
          ),
          heightSpace,
          heightSpace,
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.only(
                  left: fixPadding * 2.0,
                  right: fixPadding * 2.0,
                  top: fixPadding,
                  bottom: fixPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(width: 1.0, color: primaryColor),
              ),
              child: Text(
                'Contact host',
                style: primaryColorButtonTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  whereYouWillBwe() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(16.0), // Use your fixed padding value
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Where you\'ll be', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), // Your custom text style
          const SizedBox(height: 16), // Add spacing
          Container(
            width: width - 32.0, // Adjust based on padding
            height: 250.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                  color: Colors.grey[300]!,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: GoogleMap(
                markers: markers, // Directly use markers as a Set<Marker>
                onMapCreated: (GoogleMapController controller) {
                  // Add marker after map is created
                  Marker m = const Marker(
                    markerId: MarkerId('1'),
                    position: LatLng(47.4517861, 18.973275), // Example marker
                  );
                  setState(() {
                    markers.add(m); // Add the marker to the set
                  });
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(47.4517861, 18.973275), // Your initial position
                  zoom: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
