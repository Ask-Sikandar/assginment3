import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateScreen extends StatefulWidget {
  final String? entryId;
  final String? title;
  final String? description;
  final String? uploaderName;

  const CreateScreen({super.key, this.entryId, this.title, this.description, this.uploaderName});

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _uploaderNameController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title ?? '');
    _descriptionController = TextEditingController(text: widget.description ?? '');
    _uploaderNameController = TextEditingController(text: widget.uploaderName ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _uploaderNameController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> entryData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'uploaderName': _uploaderNameController.text,
        'profilePicture': 'https://fastly.picsum.photos/id/390/200/300.jpg?hmac=m2OBPNcWKpibmpjeOD_5Bnl5rx-6WjYtzfGnleMgyhU', // Hardcoded profile picture URL
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (widget.entryId == null) {
        // Create new entry
        await _firestore.collection('entries').add(entryData);
      } else {
        // Update existing entry
        await _firestore.collection('entries').doc(widget.entryId).update(entryData);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entryId == null ? 'Create Entry' : 'Edit Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _uploaderNameController,
                decoration: const InputDecoration(labelText: 'Uploader Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the uploader\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEntry,
                child: Text(widget.entryId == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
