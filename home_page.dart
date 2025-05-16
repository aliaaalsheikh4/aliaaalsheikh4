import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/auth/login.dart';
import 'package:my_notes/notes/firestoreService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService firestoreService = FirebaseService();

  // Text controller
  final TextEditingController textcontroller = TextEditingController();

  // method to open text box to write a new note
  void openNotesBox({String? noteId, String? initialText}) {
    if (initialText != null) {
      textcontroller.text = initialText;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textcontroller,
          decoration: InputDecoration(
            hintText: 'Enter your note here',
            hintStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600]!),
            ),
          ),
          style: TextStyle(color: Colors.black),
          maxLines: 150, 
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              if (noteId != null) {
                // Update note
                firestoreService.updateNote(noteId, textcontroller.text);
              } else {
                // Add note
                firestoreService.addNote(textcontroller.text);
              }

              // Clear the text controller
              textcontroller.clear();

              // Close the dialog
              Navigator.pop(context);
            },
            icon: Icon(Icons.save, color: Colors.white),
            label: Text('Save', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.grey[800], 
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252525),
      body: Stack(
        children: [
          Positioned(
            top: 47,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 43,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nunito',
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 21),
                    IconButton(
                      icon: const Icon(Icons.info_outline_rounded,
                          color: Colors.white),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Display notes or image if there are no notes
          StreamBuilder<QuerySnapshot>(
            stream: firestoreService.notes.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong!',
                      style: TextStyle(color: Colors.white)),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final notes = snapshot.data!.docs;

              if (notes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/images/rafiki.png',
                        fit: BoxFit.contain,
                        width: 350,
                        height: 286,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first note!',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(
                    top: 143, bottom: 112, left: 24, right: 24),
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(
                              0xFFC4C4C4), // Background color of the note container
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                note['note'],
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFF3B3B3B)),
                                  onPressed: () {
                                    openNotesBox(
                                      noteId: note.id,
                                      initialText: note['note'],
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Color(0xFF3B3B3B)),
                                  onPressed: () {
                                    firestoreService.deleteNote(note.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 49, right: 35),
        child: FloatingActionButton(
          onPressed: () => openNotesBox(),
          backgroundColor: const Color(0xFF252525),
          child: const Icon(Icons.add, color: Color(0xFFFFFFFF)),
        ),
      ),
    );
  }
}
