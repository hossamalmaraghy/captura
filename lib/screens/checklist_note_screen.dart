import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

class ChecklistNoteScreen extends StatefulWidget {
  final Note? note;

  ChecklistNoteScreen({this.note});

  @override
  _ChecklistNoteScreenState createState() => _ChecklistNoteScreenState();
}

class _ChecklistNoteScreenState extends State<ChecklistNoteScreen> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  final List<bool> _checkboxValues = [];
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      if (widget.note!.checklist != null) {
        for (var item in widget.note!.checklist!) {
          _controllers.add(TextEditingController(text: item));
          _focusNodes.add(FocusNode());
          _checkboxValues.add(false);
        }
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _titleController.dispose();
    super.dispose();
  }

  void _addChecklistItem() {
    setState(() {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
      _checkboxValues.add(false);
    });

    // Focus on the new item after it has been added
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNodes.last);
    });
  }

  void _saveChecklistNote() {
    List<String> checklistItems = _controllers.map((controller) => controller.text).toList();

    final newNote = Note(
      id: widget.note?.id ?? DateTime.now().toString(),
      title: _titleController.text,
      content: '', // No plain content for checklist note
      createdAt: widget.note?.createdAt ?? DateTime.now(),
      checklist: checklistItems,
    );

    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    if (widget.note == null) {
      noteProvider.addNote(newNote);
    } else {
      noteProvider.updateNote(newNote.id, newNote);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _saveChecklistNote,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveChecklistNote,
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
              child: ListView.builder(
                itemCount: _controllers.length + 1,
                itemBuilder: (context, index) {
                  if (index == _controllers.length) {
                    return InkWell(
                      onTap: _addChecklistItem,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(width: 8),
                            Text(
                              'Add item',
                              style: TextStyle(fontSize: 18, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Row(
                    children: [
                      Checkbox(
                        value: _checkboxValues[index],
                        onChanged: (value) {
                          setState(() {
                            _checkboxValues[index] = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          decoration: InputDecoration(
                            hintText: 'Checklist item',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            _addChecklistItem();
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
