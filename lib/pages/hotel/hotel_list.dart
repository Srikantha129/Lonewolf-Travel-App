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

class HotelList extends ConsumerStatefulWidget {
  const HotelList({super.key});

  @override
  HotelListState createState() => HotelListState();
}

class HotelListState extends ConsumerState<HotelList> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final hotelAsyncValue = ref.watch(hotelStreamProvider);

    return Scaffold(
      backgroundColor: whiteColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          hotelAsyncValue.when(
            data: (hotels) {
              debugPrint("Received hotel data: $hotels");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HotelOnMap(hotelList: hotels),
                ),
              );
            },
            loading: () {
              debugPrint("Loading hotel data...");
            },
            error: (error, stack) {
              debugPrint("Error loading hotel data: $error");
            },
          );
        },
        backgroundColor: whiteColor,
        child: Icon(
          Icons.map,
          color: primaryColor,
        ),
      ),
      body: Column(
        children: [
          // Search Bar
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
              controller: searchController,
              onChanged: (query) {
                setState(() {
                  searchQuery = query.toLowerCase(); // Update search query
                });
              },
              decoration: InputDecoration(
                hintText: 'Search hotels',
                hintStyle: greyNormalTextStyle,
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: fixPadding * 0.78,
                ),
              ),
            ),
          ),
          // Hotel List
          Expanded(
            child: hotelAsyncValue.when(
              data: (hotels) {
                final filteredHotels = hotels
                    .where((hotel) =>
                hotel.name.toLowerCase().contains(searchQuery) ||
                    (hotel.city ?? '').toLowerCase().contains(searchQuery))
                    .toList();
                return _buildHotelList(context, filteredHotels);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    const Text(
                      'Failed to load hotels. Please try again.',
                      style: TextStyle(color: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.refresh(hotelStreamProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
                        tag: '${item.hotelId}-${item.name}',
                        child: Container(
                          width: width - fixPadding * 4.0,
                          height: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10.0),
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                item.photoUrls!.first,
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
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: blackBigTextStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      ratingBar(item.ranking),
                                      const SizedBox(width: 5.0),
                                      Text('(${item.ranking}.0)', style: greySmallTextStyle),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: greyColor,
                                        size: 18.0,
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        item.city ?? 'Unknown location',
                                        style: greySmallTextStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${item.avDates?.isNotEmpty == true ? (double.tryParse(item.avDates!.first.values.first.toString())?.toStringAsFixed(1) ?? '51.0') : '51.0'}',
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

  Widget ratingBar(int number) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < number ? Icons.star : Icons.star_border,
          color: Colors.lime[600],
        );
      }),
    );
  }
}
