import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:lonewolf/pages/hotel/hotel_room.dart';

import '../../models/hotels.dart';

class HotelOnMap extends StatefulWidget {
  final List<Hotel> hotelList;
   const HotelOnMap({super.key, required this.hotelList});
  @override
  _HotelOnMapState createState() => _HotelOnMapState();
}

class _HotelOnMapState extends State<HotelOnMap> {
  GoogleMapController? _controller;

  List<Marker> allMarkers = [];

  PageController? _pageController;

  int? prevPage;

  @override
  void initState() {
    super.initState();
    for (var element in widget.hotelList) {
      if (kDebugMode) {
        print(element);
      }
      allMarkers.add(Marker(
          markerId: MarkerId(element.name),
          draggable: false,
          infoWindow:
          InfoWindow(title: element.name, snippet: element.address),
          position: LatLng(element.latitude, element.longitude)));
    }
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController!.page!.toInt() != prevPage) {
      prevPage = _pageController!.page!.toInt();
      moveCamera();
    }
  }

  _hotelFinalList(index) {
    return AnimatedBuilder(
      animation: _pageController!,
      builder: (BuildContext? context, Widget? widget) {
        double value = 1;
        if (_pageController!.position.haveDimensions) {
          value = _pageController!.page! - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 175.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          var item = widget.hotelList[index]; // Get the hotel object for the tapped index
          Navigator.push(
            context,
            PageTransition(
              duration: const Duration(milliseconds: 700),
              type: PageTransitionType.fade,
              child: HotelRoom(
                hotel: item, // Pass the hotel object here
              ),
            ),
          );
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                height: 175.0,
                width: 275.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0.0, 4.0),
                        blurRadius: 10.0,
                      ),
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: Row(
                    children: [
                      Hero(
                        tag: widget.hotelList[index].name,
                        child: Container(
                          height: 175.0,
                          width: 90.0,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0)),
                            image: DecorationImage(
                                image: AssetImage(
                                    widget.hotelList[index].photoUrls!.first),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      SizedBox(
                        width: 275.0 - 90.0 - 5.0 - 10.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start, // Remove spaceEvenly for better control of spacing
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.hotelList[index].name,
                                style: mapHeadingStyle,
                              ),
                              const SizedBox(height: 4.0), // Reduce the height of the space between the name and address
                              Text(
                                widget.hotelList[index].address,
                                style: mapAddressStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4.0), // Reduce space between address and description
                              Flexible( // Use Flexible for dynamic text length management
                                child: Text(
                                  widget.hotelList[index].hotelDescription,
                                  style: mapDescStyle,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis, // Show ellipsis when the text overflows
                                ),
                              ),
                              const SizedBox(height: 8.0), // Add a bit of space at the bottom to avoid tightness
                            ],
                          )


                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 1.0,
          title: Text(
            'Hotel',
            style: appBarTextStyle,
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height - 50.0,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.hotelList[0].latitude,
                        widget.hotelList[0].longitude),
                    zoom: 12.0),
                markers: Set.from(allMarkers),
                onMapCreated: mapCreated,
                zoomControlsEnabled: false,
              ),
            ),
            Positioned(
              bottom: 20.0,
              child: SizedBox(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.hotelList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _hotelFinalList(index);
                  },
                ),
              ),
            )
          ],
        ));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  moveCamera() {
    _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            widget.hotelList[_pageController!.page!.toInt()].latitude,
            widget.hotelList[_pageController!.page!.toInt()].longitude),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }
}
