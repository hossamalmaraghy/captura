import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/note_provider.dart';
import './screens/notes_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(      
      create: (ctx) => NoteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Captura',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: NotesListScreen(),
      ),
    );
  }
}
