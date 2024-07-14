import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import './note_detail_screen.dart';
import './checklist_note_screen.dart';

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  bool _isSingleColumnView = false;

  @override
  Widget build(BuildContext context) {
    final notesData = Provider.of<NoteProvider>(context);
    final notes = notesData.notes;

    return Scaffold(
      appBar: AppBar(
        title: Text('Captura'),
        actions: [
          IconButton(
            icon: Icon(_isSingleColumnView ? Icons.grid_view : Icons.view_agenda),
            onPressed: () {
              setState(() {
                _isSingleColumnView = !_isSingleColumnView;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 100,
                        color: Colors.grey,
                      ),
                      Text(
                        'Notes you add appear here',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _isSingleColumnView
                      ? ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            return NoteCard(
                              note: notes[index],
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NoteDetailScreen(note: notes[index]),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : MasonryGridView.count(
                          crossAxisCount: 2,
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            return NoteCard(
                              note: notes[index],
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NoteDetailScreen(note: notes[index]),
                                  ),
                                );
                              },
                            );
                          },
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        ),
                ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NoteDetailScreen(),
                  ),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.check_box),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChecklistNoteScreen(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.brush),
                        onPressed: () {
                          // Navigate to drawing note screen
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed: () {
                          // Navigate to voice note screen
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () {
                          // Navigate to image note screen
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
