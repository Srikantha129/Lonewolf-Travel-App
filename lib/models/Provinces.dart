import 'package:cloud_firestore/cloud_firestore.dart';

class Provincess {

  String? fullDescription;
  String? mapUrl;
  String? photoUrl1;
  String? photoUrl2;
  String? photoUrl3;
  String? photoUrl4;
  String? prov;
  String? title;

  Provincess({

    this.fullDescription,
    this.mapUrl,
    this.photoUrl1,
    this.photoUrl2,
    this.photoUrl3,
    this.photoUrl4,
    this.prov,
    this.title,
  });

  // Factory method to create an instance of Province from a Firestore document
  factory Provincess.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Provincess(

      fullDescription: data['fullDescription'],
      mapUrl: data['mapUrl'],
      photoUrl1: data['photoUrl1'],
      photoUrl2: data['photoUrl2'],
      photoUrl3: data['photoUrl3'],
      photoUrl4: data['photoUrl4'],
      prov: data['province'],
      title: data['title'],
    );
  }

  // Method to convert an instance of Province to a Map (useful for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'fullDescription': fullDescription,
      'mapUrl': mapUrl,
      'photoUrl1': photoUrl1,
      'photoUrl2': photoUrl2,
      'photoUrl3': photoUrl3,
      'photoUrl4': photoUrl4,
      'province': prov,
      'title': title,
    };
  }
}
