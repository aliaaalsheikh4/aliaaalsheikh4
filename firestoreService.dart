import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Get a collection of notes
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  // Add note
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

  // Update note
  Future<void> updateNote(String noteId, String newNote) {
    return notes.doc(noteId).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  // Delete note
  Future<void> deleteNote(String noteId) {
    return notes.doc(noteId).delete();
  }
}
