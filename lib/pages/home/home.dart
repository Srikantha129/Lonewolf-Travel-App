import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/experience/experience.dart';
import 'package:lonewolf/pages/places/place.dart';
import 'package:lonewolf/pages/places/recommended.dart';
import 'package:lonewolf/pages/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lonewolf/providers/popular_experiences_provider.dart';
import '../../models/popular_experiences.dart';
import '../../models/popular_places.dart';
import 'package:lonewolf/constant/static_lists.dart';
import 'package:lonewolf/providers/popular_places_provider.dart';

import '../experience/addexperience.dart';
import '../places/recommended_for_home.dart';



class Homne extends ConsumerStatefulWidget {
  const Homne({super.key});

  @override
  HomneState createState() => HomneState();
}

class HomneState extends ConsumerState<Homne> {
  String? photoURL;
  String? displayName;
  String searchQuery = '';
  List<PopularPlace> filteredPlaces = [];
  List<PopularExperience> filteredExperiences = [];
  Timer? _debounce;


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
      print('received photourl: $photoURL');
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      searchQuery = query.toLowerCase();

      // Filter places
      final allPlaces = ref.read(popularPlacesProvider).value ?? [];
      filteredPlaces = allPlaces
          .where((place) => place.name.toLowerCase().contains(searchQuery))
          .toList();

      // Filter experiences
      final allExperiences = ref.read(popularExperiencesProvider).value ?? [];
      filteredExperiences = allExperiences
          .where((experience) => experience.name.toLowerCase().contains(searchQuery))
          .toList();
    });
  }
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      filterSearchResults(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: ListView(
        children: [
          heightSpace,
          heightSpace,
          Container(
            padding: EdgeInsets.all(fixPadding * 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $displayName',  //'Hello, ${displayName?.split(' ').first ?? 'User'}'
                      style: smallBoldGreyTextStyle,
                    ),
                    Text(
                      'Start Your travel',
                      style: extraLargeBlackTextStyle,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            duration: const Duration(milliseconds: 700),
                            type: PageTransitionType.fade,
                            child: const Profile()));
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                        image: photoURL != null
                            ? CachedNetworkImageProvider(photoURL!)
                            : const AssetImage('assets/user1.jpg') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Start
          Container(
            height: 55.0,
            padding: EdgeInsets.all(fixPadding * 1.5),
            margin: EdgeInsets.all(fixPadding * 2.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(width: 1.0, color: greyColor.withOpacity(0.6)),
            ),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search city, hotel, etc',
                hintStyle: greyNormalTextStyle,
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(
                  top: fixPadding * 0.78,
                  bottom: fixPadding * 0.78,
                ),
              ),
            ),
          ),
          // Search End


          // Display filtered results or default lists
          searchQuery.isEmpty
              ? Column(
            children: [
              popularPlaces(),
              heightSpace,
              heightSpace,
              popularExperiences(),

            ],
          )
              : Column(
            children: [
              if (filteredPlaces.isNotEmpty)
                Text('Places matching "$searchQuery"', style: blackHeadingTextStyle),
              ...filteredPlaces.map((place) => ListTile(
                title: Text(place.name),
                subtitle: Text(place.property),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: Place(
                        title: place.name,
                        images: place.images,
                        description: place.description,
                        category: place.category,
                      ),
                    ),
                  );
                },
              )),
              if (filteredExperiences.isNotEmpty)
                Text('Experiences matching "$searchQuery"', style: blackHeadingTextStyle),
              ...filteredExperiences.map((experience) => ListTile(
                title: Text(experience.name),
                subtitle: Text('${experience.type} - \$${experience.price}/person'),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: Experience(experience: experience),
                    ),
                  );
                },
              )),
            ],
          ),
          // Recommended Start
          RecommendedForHome(searchQuery: searchQuery),
          // Recommended End
        ],
      ),
    );
  }


  popularPlaces() {
    double width = MediaQuery.of(context).size.width;

    // Watch the popularPlacesProvider
    final popularPlacesAsyncValue = ref.watch(popularPlacesProvider);

    return popularPlacesAsyncValue.when(
      data: (places) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: fixPadding * 2.0, left: fixPadding * 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Places to Visit', style: blackHeadingTextStyle),
                  //Text('View all', style: smallBoldGreyTextStyle),
                ],
              ),
            ),
            heightSpace,
            heightSpace,
            SizedBox(
              width: width,
              height: 150.0,
              child: ListView.builder(
                itemCount: places.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = places[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              duration: const Duration(milliseconds: 1000),
                              child: Place(
                                title: item.name,
                                images: item.images,
                                description:item.description,
                                category: item.category,
                              )));
                    },
                    child: Container(
                      width: 130.0,
                      margin: (index == places.length - 1)
                          ? EdgeInsets.only(
                          left: fixPadding, right: fixPadding * 2.0)
                          : (index == 0)
                          ? EdgeInsets.only(left: fixPadding * 2.0)
                          : EdgeInsets.only(left: fixPadding),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(item.images.first),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        width: 130.0,
                        height: 150.0,
                        padding: EdgeInsets.all(fixPadding * 1.5),
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.1, 0.5, 0.9],
                            colors: [
                              blackColor.withOpacity(0.0),
                              blackColor.withOpacity(0.3),
                              blackColor.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: whiteSmallBoldTextStyle),
                            Text(item.property,
                                style: whiteExtraSmallTextStyle),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }


  popularExperiences() {
    double width = MediaQuery.of(context).size.width;

    // Watch the popularExperiencesProvider (stream)
    final popularExperiencesAsyncValue = ref.watch(popularExperiencesProvider);

    return popularExperiencesAsyncValue.when(
      data: (experiences) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Experiences', style: blackHeadingTextStyle),
                  //Text('Check them', style: smallBoldGreyTextStyle),
                ],
              ),
            ),
            heightSpace,
            SizedBox(
              width: width,
              height: 310.0,
              child: ListView.builder(
                itemCount: experiences.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = experiences[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              duration: const Duration(milliseconds: 1000),
                              child: Experience(
                                experience: item,
                              )));
                              //child: HostExperienceForm())); // Navigate to your form
                    },
                    child: Container(
                      width: 130.0,
                      margin: EdgeInsets.only(
                        left: index == 0 ? fixPadding * 2.0 : fixPadding,
                        right: index == experiences.length - 1 ? fixPadding * 2.0 : 0,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 130.0,
                            height: 145.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: item.images.isNotEmpty
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset(
                                item.images.first, // Tries to load as AssetImage first
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback to base64 decoding if AssetImage fails
                                  try {
                                    return Image.memory(
                                      base64Decode(item.images.first),
                                      fit: BoxFit.cover,
                                    );
                                  } catch (e) {
                                    // If base64 also fails, display an error icon
                                    return const Icon(Icons.broken_image, size: 50, color: Colors.red);
                                  }
                                },
                              ),
                            )
                                : const Icon(Icons.image, size: 50, color: Colors.grey), // Placeholder if no image
                          ),
                          heightSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*Row(
                                children: [
                                  Icon(Icons.star, color: Colors.lime[600], size: 16.0),
                                  const SizedBox(width: 5.0),
                                  //Text(item.rating.toString(), style: blackSmallTextStyle),
                                ],
                              ),*/
                              const SizedBox(height: 5.0),
                              Text(
                                item.name,
                                style: blackBigTextStyle,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                item.type,
                                style: greyNormalTextStyle,
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                'From \$${item.price}/person',
                                style: blackSmallTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }




}
