import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lonewolf/constant/constant.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HostExperienceForm extends StatefulWidget {
  const HostExperienceForm({super.key});

  @override
  HostExperienceFormState createState() => HostExperienceFormState();
}

class HostExperienceFormState extends State<HostExperienceForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> uploadedImages = [];
  String? name;
  String? description;
  String? duration;
  bool isEquipmentIncluded = false;
  int maxPeople = 1;
  List<String> selectedLanguages = [];
  String? hostId;
  String? hostName;
  double? price; // New variable for price
  String? type; // New variable for type
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      String base64String = await _convertImageToBase64(imageFile);
      _uploadImageToFirestore(base64String);
    }
  }

  Future<String> _convertImageToBase64(File image) async {
    final bytes = await image.readAsBytes();
    return base64Encode(Uint8List.fromList(bytes));
  }

  Future<void> _uploadImageToFirestore(String base64String) async {
    setState(() {
      uploadedImages.add(base64String);
    });
  }

  Future<void> _getHostInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hostId = prefs.getString('userId');
      hostName = prefs.getString('userName');
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && uploadedImages.length == 3) {
      _formKey.currentState!.save();

      if (hostId == null || hostName == null) {
        await _getHostInfo();
      }

      await FirebaseFirestore.instance.collection('popular_experiences').doc(name).set({
        'name': name,
        'description': description,
        'images': uploadedImages,
        'duration': duration,
        'equipmentIncluded': isEquipmentIncluded,
        'maxPeople': maxPeople,
        'languages': selectedLanguages,
        'hostId': hostId,
        'hostName': hostName,
        'price': price, // Save price to Firestore
        'type': type,   // Save type to Firestore
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Experience added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields and upload 3 images')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getHostInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Experience'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Create Your Experience",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black45),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),

              // Title Input
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onSaved: (value) => name = value,
                validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
              ),
              SizedBox(height: 16),

              // Description Input
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                maxLines: 4,
                onSaved: (value) => description = value,
                validator: (value) => value == null || value.isEmpty ? 'Description is required' : null,
              ),
              SizedBox(height: 16),

              // Image Upload Section
              Text(
                'Upload 3 Images',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(3, (index) {
                  return InkWell(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: uploadedImages.length > index
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          base64Decode(uploadedImages[index]),
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      )
                          : Icon(Icons.upload, size: 40, color: Colors.grey[700]),
                    ),
                  );
                }),
              ),
              SizedBox(height: 16),

              // Duration Input
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Duration',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onSaved: (value) => duration = value,
                validator: (value) => value == null || value.isEmpty ? 'Duration is required' : null,
              ),
              SizedBox(height: 16),

              // Equipment Checkbox
              CheckboxListTile(
                title: Text('Includes Equipment'),
                value: isEquipmentIncluded,
                onChanged: (value) {
                  setState(() {
                    isEquipmentIncluded = value!;
                  });
                },
              ),

              // Max People Input
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Max People',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => maxPeople = int.tryParse(value!) ?? 1,
                validator: (value) => value == null || int.tryParse(value) == null ? 'Invalid number' : null,
              ),
              SizedBox(height: 16),

              // Price Input
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => price = double.tryParse(value!) ?? 0,
                validator: (value) => value == null || double.tryParse(value) == null ? 'Invalid price' : null,
              ),
              SizedBox(height: 16),

              // Type Input
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onSaved: (value) => type = value,
                validator: (value) => value == null || value.isEmpty ? 'Type is required' : null,
              ),
              SizedBox(height: 16),

              // Languages Input
              MultiSelectDialogField(
                items: ['English', 'Spanish', 'French', 'German']
                    .map((e) => MultiSelectItem(e, e))
                    .toList(),
                title: Text("Languages"),
                buttonText: Text("Select Languages"),
                initialValue: selectedLanguages,
                onConfirm: (values) {
                  setState(() {
                    selectedLanguages = values;
                  });
                },
              ),
              SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _submitForm,
                  child: Text('Submit Experience', style: TextStyle(fontSize: 16, color:Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


