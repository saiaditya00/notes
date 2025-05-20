import 'package:flutter/material.dart';
import 'package:notes/model/notes_models.dart';
import 'package:notes/screens/add_edit_screen.dart';
import 'package:notes/screens/view_notes_screen.dart';
import 'package:notes/services/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notes = [];
  // final List<Color> _noteColors = [
  //   Colors.red,
  //   Colors.green,
  //   Colors.blue,
  //   Colors.yellow,
  //   Colors.purple,
  //   Colors.orange,
  //   Colors.teal,
  //   Colors.pink,
  // ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _databaseHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          final color = Color(int.parse(note.color));

          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context)=>ViewNoteScreen(note: note)
                  ));

             
              _loadNotes();
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Text(
                    _formatDateTime(note.dateTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditNoteScreen(),
            ),
          );
          _loadNotes();
        },
        backgroundColor: Color(0xff50c878),
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}