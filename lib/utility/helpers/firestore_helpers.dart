import 'package:admin_kdv/utility/app_typednfs.dart';
import 'package:admin_kdv/utility/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension ListDocumentSnapshotExtention<T> on List<DocumentSnapshot<T>> {
  DocumentSnapshot<T>? get getLastOrNull {
    if (length == 10) {
      return last;
    }
    return null;
  }
}

extension ListDocumentReferenceX on List<DocumentReference> {
  FirebaseResult<List<T>> fetchDocuments<T>({
    required T Function(DocumentSnapshot<Map<String, dynamic>> data) fromFirestore,
  }) async {
    return Result<List<T>>().tryCatch(
      run: () async {
        if (isEmpty) return <T>[];
        // Firebase has a limit of 30 documents per batch

        const batchSize = 30;
        final results = <T>[];

        // Split references into chunks of batchSize
        for (var i = 0; i < length; i += batchSize) {
          final end = (i + batchSize < length) ? i + batchSize : length;

          final chunk = sublist(i, end);

          // Fetch documents in parallel
          final docs = await Future.wait(
            chunk.map((ref) => ref.get()),
          );

          // Convert documents to objects
          final chunkResults = docs
              .where((doc) => doc.exists && doc.data() != null)
              .map((doc) => fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
              .toList();

          results.addAll(chunkResults);
        }

        return results;
      },
    );
  }
}
