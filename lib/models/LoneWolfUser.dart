import 'dart:ffi';

class LoneWolfUser {
  String email;
  String userrole;
  List<String> favouritedPosts = [];

  LoneWolfUser({
    required this.email,
    required this.userrole,
    this.favouritedPosts = const [],
  });

  LoneWolfUser.fromJson(Map<String, Object?> json) : this(
    email: json['email']! as String,
    userrole: json['userrole']! as String,
    favouritedPosts: (json['favouritedPosts'] as List<dynamic>?)!.cast<String>(),
  );

  LoneWolfUser copyWith({
    String? email,
    String? userrole,
    List<String>? favouritedPosts,
  }) {
    return LoneWolfUser(
      email: email ?? this.email,
      userrole: userrole ?? this.userrole,
      favouritedPosts: favouritedPosts ?? this.favouritedPosts,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'userrole': userrole,
      'favouritedPosts': favouritedPosts,
    };
  }

}