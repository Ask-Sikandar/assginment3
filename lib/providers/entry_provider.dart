import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../repo/entry_repository.dart';
import '../models/entry_model.dart';

final entryRepositoryProvider = Provider<EntryRepository>((ref) => EntryRepository());

final entriesProvider = StreamProvider<List<Entry>>((ref) {
  final entryRepository = ref.watch(entryRepositoryProvider);
  return entryRepository.getEntries();
});
