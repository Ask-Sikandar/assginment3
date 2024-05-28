import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/entry_model.dart';
import '../providers/entry_provider.dart';

class CreateScreen extends ConsumerStatefulWidget {
  final Entry? entry;

  const CreateScreen({super.key, this.entry});

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _uploaderNameController = TextEditingController();

  @override
  void initState() {
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _descriptionController.text = widget.entry!.description;
      _uploaderNameController.text = widget.entry!.uploaderName;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Create Entry' : 'Edit Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _uploaderNameController,
              decoration: const InputDecoration(labelText: 'Uploader Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final entry = Entry(
                  id: widget.entry?.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  uploaderName: _uploaderNameController.text,
                  profilePicture: 'default_profile_picture_url', // Hardcoded
                  createdAt: widget.entry?.createdAt ?? DateTime.now(),
                );
                final entryRepository = ref.read(entryRepositoryProvider);
                if (widget.entry == null) {
                  await entryRepository.addEntry(entry);
                } else {
                  await entryRepository.updateEntry(entry);
                }
                Navigator.of(context).pop();
              },
              child: Text(widget.entry == null ? 'Create' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
