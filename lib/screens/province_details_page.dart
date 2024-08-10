import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/Provinces.dart';

class ProvinceDetailsPage extends StatefulWidget {
  final String province;

  const ProvinceDetailsPage({required this.province, super.key});

  @override
  State<ProvinceDetailsPage> createState() => _ProvinceDetailsPageState();
}

class _ProvinceDetailsPageState extends State<ProvinceDetailsPage> {
  List<Provincess> provin = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProvincePosts();
  }

  Future<void> _fetchProvincePosts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Provinces').get();
      List<Provincess> fetchedProvin = snapshot.docs
          .map((doc) => Provincess.fromFirestore(doc))
          .where((provincePost) => provincePost.prov == widget.province)
          .toList();
      setState(() {
        provin = fetchedProvin;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching province posts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final province = widget.province;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to $province'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : provin.isEmpty
          ? const Center(child: Text('No posts available for this province.'))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: provin.map((provincePost) {
              final List<String> imagePaths = [
                provincePost.photoUrl1 ?? '',
                provincePost.photoUrl2 ?? '',
                provincePost.photoUrl3 ?? '',
                provincePost.photoUrl4 ?? ''
              ].where((url) => url.isNotEmpty).toList();

              return Column(
                children: [
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    color: Colors.grey[100],
                    elevation: 2.0,
                    child: SizedBox(
                      height: 300.0,
                      child: PageView.builder(
                        itemCount: imagePaths.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            imagePaths[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );

                         /* return Image.network(
                            imagePaths[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );*/
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5.0),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            provincePost.title ?? '',
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          provincePost.fullDescription ?? '',
                          style: const TextStyle(
                              fontSize: 14.0, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => launch(provincePost.mapUrl ?? ''),
                          child: const Card(
                            color: Colors.grey,
                            child: Padding(
                              padding: EdgeInsets.all(25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.flight_takeoff, color: Colors.white),
                                  Text(
                                    'Travel Guide',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );

  }
}
