import 'package:flutter/material.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/models/popular_places.dart';
import 'package:lonewolf/pages/places/recommended.dart';
import 'package:lonewolf/pages/places/recommended_for_city.dart';
import 'package:lonewolf/widget/carousel_pro/lib/carousel_pro.dart';

class Place extends StatefulWidget {
  final String? title;
  final List<String> images;
  final List<Category> category;
  final String? description;
  const Place({super.key, @required this.title, required this.images, required this.description, required this.category,});
  @override
  PlaceState createState() => PlaceState();
}

class PlaceState extends State<Place> {
  final topDestinationList = [
    {
      'title': 'Eiffel Tower',
      'image': 'assets/top_destination/top_destination_1.jpg',
      'location': 'Paris',
      'rating': '4.9'
    },
    {
      'title': 'Louvre Museum',
      'image': 'assets/top_destination/top_destination_2.jpg',
      'location': 'Paris',
      'rating': '4.4'
    },
    {
      'title': 'Cathédrale Notre-Dame',
      'image': 'assets/top_destination/top_destination_3.jpg',
      'location': 'Paris',
      'rating': '4.5'
    },
    {
      'title': 'Arc de Triomphe',
      'image': 'assets/top_destination/top_destination_4.jpg',
      'location': 'Paris',
      'rating': '4.0'
    },
    {
      'title': 'Musée d\'Orsay',
      'image': 'assets/top_destination/top_destination_5.jpg',
      'location': 'Paris',
      'rating': '4.3'
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        centerTitle: true,
        title: Text(widget.title!, style: appBarTextStyle),
      ),
      body: ListView(
        children: [
          // Slider Start
          slider(),
          // Slider End
          // Detail Start
          details(),
          // Detail End
          // Category Start
          category(),
          // Category End
          // Top Destinations Start
          //topDestination(),
          // Top Destinations End
          // Recommended Start
          RecommendedForCity(city: widget.title!,),
          // Recommended End
        ],
      ),
    );
  }

  slider() {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 200.0,
      width: width,
      child: Carousel(
        images: widget.images.map((imagePath) => ExactAssetImage(imagePath)).toList(),
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


  details() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title!,
            style: blackHeadingTextStyle,
          ),
          heightSpace,
          Text(
            widget.description!,
            style: greySmallTextStyle,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  category() {
    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category',
            style: blackHeadingTextStyle,
          ),
          heightSpace,
          heightSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: widget.category.map<Widget>((category) {
            return getCategoryTile(category.icon, category.name);
          }).toList(),
        )



    ],
      ),
    );
  }

  getCategoryTile(iconPath, title) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 35.0, height: 35.0, fit: BoxFit.cover),
          const SizedBox(height: 5.0),
          Text(title, style: blackExtraSmallTextStyle)
        ],
      ),
    );
  }

  /*topDestination() {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(fixPadding * 2.0),
          child: Text(
            'Top Destination',
            style: blackHeadingTextStyle,
          ),
        ),
        Container(
          width: width,
          height: 260.0,
          child: ListView.builder(
            itemCount: topDestinationList.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final item = topDestinationList[index];
              return InkWell(
                onTap: () {},
                child: Container(
                  margin: (index == topDestinationList.length - 1)
                      ? EdgeInsets.only(
                          left: fixPadding * 2.0, right: fixPadding * 2.0)
                      : EdgeInsets.only(left: fixPadding * 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      heightSpace,
                      Container(
                        width: 200.0,
                        height: 100.0,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title']!, style: blackBigTextStyle),
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: greyColor,
                                  size: 18.0,
                                ),
                                const SizedBox(width: 5.0),
                                Text(item['location']!,
                                    style: greySmallTextStyle),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.star,
                                    color: Colors.lime[600], size: 16.0),
                                const SizedBox(width: 5.0),
                                Text(item['rating']!,
                                    style: blackSmallTextStyle),
                              ],
                            ),
                          ],
                        ),
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
  }*/
}
