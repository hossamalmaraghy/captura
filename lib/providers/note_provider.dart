import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/database.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  final DatabaseService _databaseService = DatabaseService();

  NoteProvider() {
    _loadNotes();
  }

  List<Note> get notes => _notes;

  Future<void> _loadNotes() async {
    _notes = await _databaseService.notes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _databaseService.insertNote(note);
    _notes.add(note);
    notifyListeners();
  }

  Future<void> updateNote(String id, Note newNote) async {
    await _databaseService.updateNote(newNote);
    final noteIndex = _notes.indexWhere((note) => note.id == id);
    if (noteIndex >= 0) {
      _notes[noteIndex] = newNote;
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    await _databaseService.deleteNote(id);
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }
}
