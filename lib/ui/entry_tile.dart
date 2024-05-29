import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'create_screen.dart';

class EntryTile extends StatelessWidget {
  final DocumentSnapshot entry;

  const EntryTile({super.key, required this.entry});

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 1) {
      return DateFormat.yMMMd().add_jm().format(dateTime);
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${DateFormat.jm().format(dateTime)}';
    } else {
      return 'Today at ${DateFormat.jm().format(dateTime)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(entry['profilePicture'] ?? 'https://example.com/default_profile_picture.png'),
      ),
      title: Text(entry['title']),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entry['description']),
          Text('Uploaded by: ${entry['uploaderName']}'),
          Text('Created at: ${entry['createdAt'].toDate()}'),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateScreen(
              entryId: entry.id,
              title: entry['title'],
              description: entry['description'],
              uploaderName: entry['uploaderName'],
            ),
          ),
        );
      },
    );

  }
}
