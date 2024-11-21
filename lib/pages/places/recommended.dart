import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/hotel/hotel_room.dart';
import 'package:lonewolf/widget/column_builder.dart';
import 'package:lonewolf/providers/hotels_provider.dart';

class Recommended extends ConsumerWidget {
  const Recommended({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;

    // Use the StreamProvider
    final hotelStream = ref.watch(hotelStreamProvider);

    return Container(
      padding: EdgeInsets.all(fixPadding * 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recommended', style: blackHeadingTextStyle),
          heightSpace,
          heightSpace,
          hotelStream.when(
            data: (hotels) {
              debugPrint("Received hotels: $hotels");
              final recommendedList = hotels.take(10).toList(); // Only the first 10 hotels
              return ColumnBuilder(
                itemCount: recommendedList.length,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                itemBuilder: (context, index) {
                  final item = recommendedList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: const Duration(milliseconds: 700),
                          type: PageTransitionType.fade,
                          child: HotelRoom(
                            // title: item.name,
                            // imgPath: item.photoUrls?.first, // Placeholder for image URL
                            //   price: '\$${item.avDates?.first.values.first ?? 'N/A'}',// Access the price from the first map in avDates
                             hotel: item,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: width - fixPadding * 4.0,
                      margin: EdgeInsets.only(
                        top: (index != 0) ? fixPadding * 2.0 : 0.0,
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
                      /*child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: item.name,
                            child: Container(
                              width: width - fixPadding * 4.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10.0)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    item.photoUrls!.first, // Placeholder for image URL
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(fixPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: width - (fixPadding * 6.0 + 65.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: blackBigTextStyle,
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          ratingBar(item.ranking), // Use ranking as the rating
                                          const SizedBox(width: 5.0),
                                          Text('(${item.ranking}.0)',
                                              style: greySmallTextStyle),
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: greyColor,
                                            size: 18.0,
                                          ),
                                          const SizedBox(width: 5.0),
                                          Text(item.city,
                                              style: greySmallTextStyle),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '\$${item.avDates?.first.values.first ?? 'N/A'}', // Access the first value in the first map (price)
                                      style: bigPriceTextStyle,
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text('per night', style: greySmallTextStyle),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),*/
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: item.name,
                            child: Container(
                              width: width - fixPadding * 4.0,
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
                                image: DecorationImage(
                                  image: _getImageProvider(item.photoUrls!.first),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(fixPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: width - (fixPadding * 6.0 + 80.0), // Adjusted width to allow space for the price column
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: blackBigTextStyle,
                                        overflow: TextOverflow.ellipsis, // Prevents overflow
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ratingBar(item.ranking), // Use ranking as the rating
                                          const SizedBox(width: 5.0),
                                          Text(
                                            '(${item.ranking}.0)',
                                            style: greySmallTextStyle,
                                            overflow: TextOverflow.ellipsis, // Prevents overflow
                                          ),
                                        ],
                                      ),
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
                                          Text(
                                            item.city,
                                            style: greySmallTextStyle,
                                            overflow: TextOverflow.ellipsis, // Prevents overflow
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 80.0, // Fixed width for the price section
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '\$${item.avDates?.first.values.first ?? '70'}', // Access the first value in the first map (price)
                                        style: bigPriceTextStyle,
                                        textAlign: TextAlign.center, // Align text properly
                                        overflow: TextOverflow.ellipsis, // Prevent overflow
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(
                                        'per night',
                                        style: greySmallTextStyle,
                                        textAlign: TextAlign.center, // Align text properly
                                        overflow: TextOverflow.ellipsis, // Prevent overflow
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ],
      ),
    );
  }

  ratingBar(number) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon((number >= 1) ? Icons.star : Icons.star_border,
            color: Colors.lime[600]),
        Icon((number >= 2) ? Icons.star : Icons.star_border,
            color: Colors.lime[600]),
        Icon((number >= 3) ? Icons.star : Icons.star_border,
            color: Colors.lime[600]),
        Icon((number >= 4) ? Icons.star : Icons.star_border,
            color: Colors.lime[600]),
        Icon((number >= 5) ? Icons.star : Icons.star_border,
            color: Colors.lime[600]),
      ],
    );
  }
}
ImageProvider _getImageProvider(String imageUrl) {
  try {
    // Attempt to load asset image first
    return AssetImage(imageUrl);
  } catch (_) {
    // Fallback to network image
    return NetworkImage(imageUrl);
  }
}
