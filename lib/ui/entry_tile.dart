import 'package:flutter/material.dart';
import '../models/entry_model.dart';
import 'create_screen.dart';

class EntryTile extends StatelessWidget {
  final Entry entry;

  const EntryTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(entry.title),
      subtitle: Text(entry.description),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreateScreen(entry: entry),
          ),
        );
      },
    );
  }
}
