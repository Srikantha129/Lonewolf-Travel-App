/*
class PopularPlace {
  final String name;
  final List<String> images; // Change to List<String> for multiple images
  final String property;
  final String description;
  final List<String> category;

  PopularPlace({
    required this.name,
    required this.images,
    required this.property,
    required this.description,
    required this.category,
  });

  factory PopularPlace.fromJson(Map<String, dynamic> json) {
    return PopularPlace(
      name: json['name'],
      images: List<String>.from(json['images']), // Parse the list of images
      property: json['property'],
      description: json['description'],
      category: List<String>.from(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'images': images, // Convert the list of images to JSON
      'property': property,
      'description': description,
      'category': category,
    };
  }
}
*/

class PopularPlace {
  final String name;
  final List<String> images; // Multiple images
  final String property;
  final String description;
  final List<Category> category; // Change this to List<Category> for complex structure

  PopularPlace({
    required this.name,
    required this.images,
    required this.property,
    required this.description,
    required this.category,
  });

  factory PopularPlace.fromJson(Map<String, dynamic> json) {
    return PopularPlace(
      name: json['name'],
      images: List<String>.from(json['images']),
      property: json['property'],
      description: json['description'],
      category: (json['category'] as List)
          .map((item) => Category.fromJson(item))
          .toList(), // Parse list of Category objects
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'images': images,
      'property': property,
      'description': description,
      'category': category.map((item) => item.toJson()).toList(), // Convert list of Category objects to JSON
    };
  }
}

class Category {
  final String name;
  final String icon;

  Category({
    required this.name,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
    };
  }
}
