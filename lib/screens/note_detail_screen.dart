import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note? note;

  NoteDetailScreen({this.note});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _isPinned = widget.note!.isPinned;
    }
  }

  void _saveNote() {
    if (_titleController.text.isNotEmpty || _contentController.text.isNotEmpty) {
      final newNote = Note(
        id: widget.note?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        content: _contentController.text,
        createdAt: widget.note?.createdAt ?? DateTime.now(),
        isPinned: _isPinned,
      );

      final noteProvider = Provider.of<NoteProvider>(context, listen: false);

      if (widget.note == null) {
        noteProvider.addNote(newNote);
        print("Note added: ${newNote.title}");
      } else {
        noteProvider.updateNote(newNote.id, newNote);
        print("Note updated: ${newNote.title}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (void shouldPop) {
        _saveNote();
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              onPressed: () {
                setState(() {
                  _isPinned = !_isPinned;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.notification_add),
              onPressed: () {
                // Handle notifications
              },
            ),
            IconButton(
              icon: Icon(Icons.lock),
              onPressed: () {
                // Handle lock
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                if (widget.note != null) {
                  Provider.of<NoteProvider>(context, listen: false).deleteNote(widget.note!.id);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'Note',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add_box),
                      onPressed: () {
                        // Handle adding a box
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.color_lens),
                      onPressed: () {
                        // Handle color change
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.text_format),
                      onPressed: () {
                        // Handle text formatting
                      },
                    ),
                  ],
                ),
                Text(
                  'Edited ${DateTime.now().hour}:${DateTime.now().minute}',
                  style: TextStyle(color: Colors.grey),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    // Handle more options
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
