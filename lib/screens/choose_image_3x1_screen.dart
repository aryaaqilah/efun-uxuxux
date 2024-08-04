import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/helper/app_image_picker.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:photo_editor/screens/filter_screen.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class SelectedCard3x1Page extends StatefulWidget {
  final int cardIndex;

  SelectedCard3x1Page({required this.cardIndex});

  @override
  _SelectedCard3x1PageState createState() => _SelectedCard3x1PageState();
}

class _SelectedCard3x1PageState extends State<SelectedCard3x1Page> {
  late AppImageProvider imageProvider;
  List<File?> images = [null, null, null];
  List<List<File?>> undoHistory = [];
  List<List<File?>> redoHistory = [];
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  Future<void> _pickImage(int index, ImageSource source) async {
    AppImagePicker(source: source).pick(onPick: (File? image) {
      if (image != null) {
        setState(() {
          // Save current state to undo history
          undoHistory.add(List.from(images));
          // Clear redo history
          redoHistory.clear();
          images[index] = image;
        });
      }
    });
  }

  void _undo() {
    if (undoHistory.isNotEmpty) {
      setState(() {
        // Save current state to redo history
        redoHistory.add(List.from(images));
        // Restore previous state from undo history
        images = undoHistory.removeLast();
      });
    }
  }

  void _redo() {
    if (redoHistory.isNotEmpty) {
      setState(() {
        // Save current state to undo history
        undoHistory.add(List.from(images));
        // Restore next state from redo history
        images = redoHistory.removeLast();
      });
    }
  }

  void _validateAndProceed() async {
    if (images.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all images')),
      );
    } else {
      Uint8List? bytes = await screenshotController.capture();
      imageProvider.changeImage(bytes!);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilterScreen(layoutIndex: widget.cardIndex),
        ),
      );
    }
  }

  void _showImageOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                setState(() {
                  // Save current state to undo history
                  undoHistory.add(List.from(images));
                  // Clear redo history
                  redoHistory.clear();
                  images[index] = null;
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Cancel'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int index = widget.cardIndex + 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F4F4),
        toolbarHeight: 60,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/layout');
            }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _undo,
              icon: Icon(Icons.undo,
                  color: undoHistory.isNotEmpty ? Colors.black : Colors.grey),
            ),
            const SizedBox(width: 8),
            const Text(
              "Add Image",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _redo,
              icon: Icon(Icons.redo,
                  color: redoHistory.isNotEmpty ? Colors.black : Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: _validateAndProceed, icon: const Icon(Icons.done))
        ],
      ),
      body: Container(
        color: const Color(0xFFD9D9D9),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Screenshot(
                controller: screenshotController,
                child: Container(
                  width: 357,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 357,
                          height: 500,
                          // color: Colors.cyan,
                          child: Image.asset('assets/layout/$index.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Center(
                          child: Container(
                            width: 300,
                            // color: Colors.brown,
                            height: 390,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(3, (i) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: images[i] != null
                                          ? () => _showImageOptions(i)
                                          : null,
                                      child: images[i] == null
                                          ? Container(
                                              // color: Colors.cyan,
                                              width: 283,
                                              height: 110,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(Icons
                                                            .add_photo_alternate),
                                                        onPressed: () =>
                                                            _pickImage(
                                                                i,
                                                                ImageSource
                                                                    .gallery),
                                                      ),
                                                      Text("Gallery",
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          20), // memberikan jarak antar kolom
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(
                                                            Icons.camera_alt),
                                                        onPressed: () =>
                                                            _pickImage(
                                                                i,
                                                                ImageSource
                                                                    .camera),
                                                      ),
                                                      Text("Camera",
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              width: 286,
                                              color: Colors.black,
                                              child: Image.file(
                                                images[i]!,
                                                width: 100,
                                                height: 115,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Text('You selected card ${widget.cardIndex}'),
            ],
          ),
        ),
      ),
    );
  }
}
