// import 'package:carousel_slider/carousel_controller.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class OldBlogPage extends StatefulWidget {
//   const OldBlogPage({required int blogNo, super.key});
//
//   @override
//   State<OldBlogPage> createState() => _OldBlogPageState();
// }
//
// class _OldBlogPageState extends State<OldBlogPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final List<String> imagePaths = [
//     'assets/images/sigiriya1.jpg',
//     'assets/images/sigiriya2.jpg',
//     'assets/images/sigiriya3.jpg'
//   ];
//   bool isFavourited = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Image.asset(
//           'assets/images/IconOnly.png',
//           height: 30.0,
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 setState(() {
//                   isFavourited = !isFavourited;
//                 });
//               },
//               icon: isFavourited
//                   ? const Icon(
//                       Icons.favorite,
//                       color: Colors.red,
//                     )
//                   : const Icon(Icons.favorite_border_outlined)),
//           IconButton(
//             icon: const Icon(Icons.logout_outlined),
//             onPressed: _auth.signOut,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Column(
//                 children: [
//                   const Align(
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       '2024 Feb 20',
//                       style: TextStyle(
//                         fontSize: 13.0,
//                       ),
//                     ),
//                   ),
//                   const Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       'Sri Lanka\'s Lion Rock Fortress Unveiled',
//                       style: TextStyle(
//                           fontSize: 20.0, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//
//                   // CarouselSlider(
//                   //   items: imagePaths.map((imagePath) => Image.asset(imagePath, fit: BoxFit.cover)).toList(),
//                   //   carouselController: CarouselController(),
//                   //   options: CarouselOptions(
//                   //     height: 300.0,
//                   //     autoPlay: true,
//                   //     autoPlayInterval: const Duration(seconds: 5),
//                   //     autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                   //     enlargeCenterPage: false,
//                   //   ),
//                   // ),
//                   Card(
//                     clipBehavior: Clip.antiAliasWithSaveLayer,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                     color: Colors.grey[100],
//                     elevation: 2.0,
//                     child: SizedBox(
//                       height: 300.0,
//                       child: PageView.builder(
//                         itemCount: imagePaths.length,
//                         itemBuilder: (context, index) {
//                           return Image.asset(
//                             imagePaths[index],
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   // Image.asset(
//                   //   'assets/images/sigiriya1.jpg',
//                   //   fit: BoxFit.cover,
//                   //   height: 300.0,
//                   //   width: double.infinity,
//                   // ),
//                   Container(
//                     padding: const EdgeInsets.all(10.0), // Add some padding
//                     child: const Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 5.0),
//                         Text(
//                           'Sigiriya, Located in the heart of Sri Lanka. This UNESCO World Heritage Site boasts a unique combination of nature, culture, and history, captivating travelers worldwide.',
//                           style:
//                               TextStyle(fontSize: 14.0, color: Colors.black54),
//                         ),
//                         SizedBox(height: 5.0),
//                         Text(
//                           'A Soaring Citadel:',
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.black54,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 5.0),
//                         Text(
//                           ''' Rising nearly 200 meters (660 ft) from the surrounding plains, Sigiriya's iconic rock formation was once a volcanic plug. In the 5th century AD, King Kashyapa transformed this natural wonder into a magnificent fortress-palace. The ascent to the summit is a fascinating journey itself. Visitors climb a series of staircases built into the rock face, passing by the awe-inspiring "Lion Gate" – a colossal sculpture of a lion's paws guarding the entrance.''',
//                           style:
//                               TextStyle(fontSize: 14.0, color: Colors.black54),
//                         ),
//                         SizedBox(height: 5.0),
//                         Text(
//                           ''' Halfway up the climb, a marvel of ancient engineering awaits: the "Mirror Wall." This polished rock face was once coated with a special plaster that reflected light, earning its name. Today, remnants of frescoes depicting celestial maidens (known as "apsara") adorn the remaining sections, offering a glimpse into the artistic expressions of the era. ''',
//                           style:
//                               TextStyle(fontSize: 14.0, color: Colors.black54),
//                         ),
//                         SizedBox(height: 5.0),
//                         Text(
//                           ''' Reaching the summit reveals the remnants of the royal palace complex. Ruins of pools, gardens, and audience halls stand as testaments to the grandeur of Kashyapa's kingdom. The breathtaking panoramic view from the top rewards the climb, showcasing lush greenery, distant mountains, and shimmering reservoirs. ''',
//                           style:
//                               TextStyle(fontSize: 14.0, color: Colors.black54),
//                         ),
//                         SizedBox(height: 5.0),
//                         Text(
//                           'More Than Just a Palace:',
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.black54,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 5.0),
//                         Text(
//                           '''Sigiriya's significance extends beyond its architectural marvels. Archaeological evidence suggests it was also a center for urban planning, irrigation systems, and advanced water management techniques. The site continues to hold a mystical aura, with legends and folklore woven into its history. ''',
//                           style:
//                               TextStyle(fontSize: 14.0, color: Colors.black54),
//                         ),
//                         SizedBox(height: 5.0),
//                         Text(
//                           'A Must-See for Travelers',
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               color: Colors.black54,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 5.0),
//                         Text(
//                           '''Today, Sigiriya is a popular tourist destination, attracting visitors from around the globe. Guided tours offer insights into the site's history and significance. Visitors can also explore the surrounding archaeological gardens and museums for a deeper understanding of this ancient kingdom.''',
//                           style:
//                               TextStyle(fontSize: 14.0, color: Colors.black54),
//                         ),
//                         SizedBox(height: 5.0),
//                         Text(
//                           '''Whether you're a history buff, an art enthusiast, or simply someone who appreciates breathtaking scenery, Sigiriya offers an unforgettable experience. This unique blend of nature, culture, and history makes it a must-see for anyone visiting Sri Lanka. ''',
//                           style:
//                               TextStyle(fontSize: 14.0, color: Colors.black54),
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               '#hashtag1',
//                               style:
//                                   TextStyle(fontSize: 12.0, color: Colors.blue),
//                             ),
//                             SizedBox(width: 5.0),
//                             Text(
//                               '#hashtag2',
//                               style:
//                                   TextStyle(fontSize: 12.0, color: Colors.blue),
//                             ),
//                             SizedBox(width: 5.0),
//                             Text(
//                               '#hashtag3',
//                               style:
//                                   TextStyle(fontSize: 12.0, color: Colors.blue),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: InkWell(
//                       onTap: () {},
//                       child: const Card(
//                         color: Colors.grey,
//                         child: Padding(
//                           padding:
//                               EdgeInsets.all(25.0), // Adjust padding as needed
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Icon(Icons.flight_takeoff, color: Colors.white),
//                               Text(
//                                 'Travel Guide',
//                                 style: TextStyle(fontSize: 20.0),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10.0),
//               const Text(
//                 'You might also like ',
//                 style: TextStyle(
//                     fontSize: 16.0,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10.0),
//               Row(
//                 children: [
//                   Expanded(
//                     child: InkWell(
//                       onTap:  () => launch('https://maps.app.goo.gl/PWhYGEJzFYHqXM5b6'),
//                       child: const Card(
//                         color: Colors.green,
//                         child: Padding(
//                           padding:EdgeInsets.all(25.0), // Adjust padding as needed
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Icon(Icons.flight_takeoff, color: Colors.white),
//                               Text(
//                                 'Travel Guide',
//                                 style: TextStyle(fontSize: 20.0),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: InkWell(
//                       onTap: () {},
//                       child: const Card(
//                         color: Colors.blueAccent,
//                         child: Padding(
//                           padding:
//                           EdgeInsets.all(25.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Icon(Icons.flight_takeoff, color: Colors.white),
//                               Text(
//                                 'Travel Guide',
//                                 style: TextStyle(fontSize: 20.0),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // void launchGoogleMaps() async {
//   //   const url = 'https://maps.app.goo.gl/9SXpHbFoWGxuK4qv5';
//   //   if (await canLaunchUrlString(url)) {
//   //     await launchUrlString(url);
//   //   } else {
//   //     throw 'Could not launch $url';
//   //   }
//   // }
// }
