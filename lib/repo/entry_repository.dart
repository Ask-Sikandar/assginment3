import '../services/firestore_service.dart';
import '../models/entry_model.dart';

class EntryRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<Entry>> getEntries() {
    return _firestoreService.getEntries();
  }

  Future<void> addEntry(Entry entry) {
    return _firestoreService.addEntry(entry);
  }

  Future<void> updateEntry(Entry entry) {
    return _firestoreService.updateEntry(entry);
  }
}
