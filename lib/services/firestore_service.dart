import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/entry_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Entry>> getEntries() {
    return _db.collection('entries').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Entry.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Future<void> addEntry(Entry entry) async {
    await _db.collection('entries').add(entry.toMap());
  }

  Future<void> updateEntry(Entry entry) async {
    await _db.collection('entries').doc(entry.id).update(entry.toMap());
  }
}
