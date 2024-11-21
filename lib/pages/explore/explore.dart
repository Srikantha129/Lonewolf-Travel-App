import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/hotel/hotel_list.dart';


class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {


  final experienceFavoriteList = [
    {
      'name': 'Wine not taste our passion?',
      'image': 'assets/popular_experiences/popular_experiences_1.jpg',
      'type': 'Wine tasting',
      'price': '35',
      'rating': '4.9'
    },
    {
      'name': 'Fine Wines & Ruin Bars',
      'image': 'assets/popular_experiences/popular_experiences_2.jpg',
      'type': 'Wine tasting',
      'price': '61',
      'rating': '5.0'
    },
    {
      'name': 'Budapest Boat Cruise With a Bonus Drink',
      'image': 'assets/popular_experiences/popular_experiences_3.jpg',
      'type': 'Boat ride',
      'price': '31',
      'rating': '4.81'
    },
    {
      'name': 'Budapest Historic and Cultural Tour',
      'image': 'assets/popular_experiences/popular_experiences_4.jpg',
      'type': 'History walk',
      'price': '64',
      'rating': '5.0'
    }
  ];

  final experienceFavouriteList = [];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          centerTitle: true,
          elevation: 1.0,
          automaticallyImplyLeading: false,
          title: Text(
            'Explore More',
            style: appBarTextStyle,
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Hotel'),
              Tab(text: 'Experiences'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const HotelList(),
            experience(),
          ],
        ),
      ),
    );
  }



  ratingBar(number) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1 Star
        Icon(
            (number == 1 ||
                    number == 2 ||
                    number == 3 ||
                    number == 4 ||
                    number == 5)
                ? Icons.star
                : Icons.star_border,
            color: Colors.lime[600]),

        // 2 Star
        Icon(
            (number == 2 || number == 3 || number == 4 || number == 5)
                ? Icons.star
                : Icons.star_border,
            color: Colors.lime[600]),

        // 3 Star
        Icon(
            (number == 3 || number == 4 || number == 5)
                ? Icons.star
                : Icons.star_border,
            color: Colors.lime[600]),

        // 4 Star
        Icon((number == 4 || number == 5) ? Icons.star : Icons.star_border,
            color: Colors.lime[600]),

        // 5 Star
        Icon((number == 5) ? Icons.star : Icons.star_border,
            color: Colors.lime[600]),
      ],
    );
  }

  experience() {
    double width = MediaQuery.of(context).size.width;
    return (experienceFavoriteList.length == 0)
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.local_drink,
                  color: Colors.grey,
                  size: 60.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'No Item in Favorite Experiences',
                  style: smallBoldGreyTextStyle,
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: experienceFavoriteList.length,
            itemBuilder: (context, index) {
              final item = experienceFavoriteList[index];
              return InkWell(
                onTap: () {},
                child: Slidable(
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.16,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            experienceFavoriteList.removeAt(index);
                          });

                          // Then show a snackbar.
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Experience Removed from Favorite'),
                          ));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: fixPadding * 2.0,
                            bottom: (index == experienceFavoriteList.length - 1)
                                ? fixPadding * 2.0
                                : 0.0,
                          ),
                          width: MediaQuery.of(context).size.width * 0.16,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
                    child: Container(
                      width: width - fixPadding * 4.0,
                      margin: EdgeInsets.only(
                        top: fixPadding * 2.0,
                        bottom: (index == experienceFavoriteList.length - 1)
                            ? fixPadding * 2.0
                            : 0.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: whiteColor,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            blurRadius: 1.0,
                            spreadRadius: 1.0,
                            color: Colors.grey[300]!,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 110.0,
                            height: 170.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10.0)),
                              image: DecorationImage(
                                  image: AssetImage(item['image']!),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Container(
                            width: width - (fixPadding * 4.0 + 110.0),
                            height: 170.0,
                            padding: EdgeInsets.all(fixPadding * 2.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name']!,
                                  style: blackBigTextStyle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  item['type']!,
                                  style: greyNormalTextStyle,
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'From \$${item['price']}/person',
                                  style: blackSmallTextStyle,
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.lime[600], size: 16.0),
                                    SizedBox(width: 5.0),
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
                  ),
                ),
              );
            },
          );
  }
}
