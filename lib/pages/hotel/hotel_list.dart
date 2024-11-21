import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/hotel/hotel_on_map.dart';
import 'package:lonewolf/pages/hotel/hotel_room.dart';
import 'package:lonewolf/widget/column_builder.dart';
import 'package:lonewolf/models/hotels.dart';
import 'package:lonewolf/services/hotels_db_service.dart';
import 'package:lonewolf/providers/hotels_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HotelList extends ConsumerWidget {
  const HotelList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotelAsyncValue = ref.watch(hotelStreamProvider);

    return Scaffold(
      backgroundColor: whiteColor,
      /*appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 1.0,
        titleSpacing: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        //title: Text('Hotel', style: appBarTextStyle),
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          hotelAsyncValue.when(
            data: (hotels) {
              debugPrint("received hotel datas: $hotels");
              // Pass the data to the map view if needed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HotelOnMap(hotelList: hotels,),
                ),
              );
            },
            loading: () {},
            error: (error, stack) {},
          );
        },
        backgroundColor: whiteColor,
        child: Icon(
          Icons.map,
          color: primaryColor,
        ),
      ),
      body: hotelAsyncValue.when(
        data: (hotels) => _buildHotelList(context, hotels),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(child: Text('Error loading hotels')),
      ),
    );
  }

  Widget _buildHotelList(BuildContext context, List<Hotel> hotelList) {
    double width = MediaQuery.of(context).size.width;

    // Only take the first 15 hotels
    List<Hotel> limitedHotelList = hotelList.take(15).toList();

    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(fixPadding * 2.0),
          child: ColumnBuilder(
            itemCount: limitedHotelList.length,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            itemBuilder: (context, index) {
              final item = limitedHotelList[index];
              //debugPrint('pricee:${item.avDates?.first.values.first ?? '51'}');

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      duration: const Duration(milliseconds: 700),
                      type: PageTransitionType.fade,
                      child: HotelRoom(
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
                  child: Column(
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
                              top: Radius.circular(10.0),
                            ),
                            image: DecorationImage(
                              image: AssetImage(
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
                              width: width - (fixPadding * 6.0 + 70.0),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ratingBar(item.ranking),
                                      const SizedBox(width: 5.0),
                                      Text('(${item.ranking}.0)', style: greySmallTextStyle),
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
                                      //Text(item.location, style: greySmallTextStyle),
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
                                  '50',
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
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
}
