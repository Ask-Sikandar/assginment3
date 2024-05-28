import 'package:cloud_firestore/cloud_firestore.dart';

class Entry {
  final String? id;
  final String title;
  final String description;
  final String uploaderName;
  final String profilePicture;
  final DateTime createdAt;

  Entry({
    this.id,
    required this.title,
    required this.description,
    required this.uploaderName,
    required this.profilePicture,
    required this.createdAt,
  });

  factory Entry.fromFirestore(Map<String, dynamic> data, String id) {
    return Entry(
      id: id,
      title: data['title'],
      description: data['description'],
      uploaderName: data['uploaderName'],
      profilePicture: data['profilePicture'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'uploaderName': uploaderName,
      'profilePicture': profilePicture,
      'createdAt': createdAt,
    };
  }
}
