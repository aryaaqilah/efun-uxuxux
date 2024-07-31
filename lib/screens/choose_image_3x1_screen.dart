import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/helper/app_image_picker.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class SelectedCard3x1Page extends StatefulWidget {
  final int cardIndex;

  SelectedCard3x1Page({required this.cardIndex});

  @override
  _SelectedCard3x1PageState createState() => _SelectedCard3x1PageState();
}

class _SelectedCard3x1PageState extends State<SelectedCard3x1Page> {
  late AppImageProvider imageProvider;
  List<File?> images = [null, null, null];
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
          images[index] = image;
        });
      }
    });
  }

  Future<void> _captureAndSaveScreenshot(BuildContext context) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    String fileName = 'polaroid_${DateTime.now().millisecondsSinceEpoch}.jpg';
    String filePath = '$directory/$fileName';

    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        final File imageFile = File(filePath);
        await imageFile.writeAsBytes(image);
        // await ImageGallerySaver.saveFile(filePath);
        // print('Screenshot saved to gallery');
        imageProvider.changeImageFile(imageFile);

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DisplayImagePage(
              imageFile: imageFile, imageProvider: imageProvider),
        ));
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    int index = widget.cardIndex + 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Card Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () => _captureAndSaveScreenshot(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Screenshot(
              controller: screenshotController,
              child: Stack(
                children: [
                  Container(
                    width: 400,
                    height: 500,
                    child: Image.asset('assets/layout/$index.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 42.0),
                    child: Container(
                      width: 400,
                      height: 385,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(3, (i) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              images[i] == null
                                  ? Container(
                                      width: 283,
                                      height: 110,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon:
                                                Icon(Icons.add_photo_alternate),
                                            color: Colors.red,
                                            onPressed: () => _pickImage(
                                                i, ImageSource.gallery),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.camera_alt),
                                            color: Colors.blue,
                                            onPressed: () => _pickImage(
                                                i, ImageSource.camera),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      width: 283,
                                      color: Colors.amber,
                                      child: Image.file(
                                        images[i]!,
                                        width: 100,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text('You selected card ${widget.cardIndex}'),
          ],
        ),
      ),
    );
  }
}

class DisplayImagePage extends StatelessWidget {
  final File imageFile;
  final AppImageProvider imageProvider;

  DisplayImagePage({required this.imageFile, required this.imageProvider});

  Future<void> _savePhoto(BuildContext context) async {
    final result = await ImageGallerySaver.saveImage(
      imageFile.readAsBytesSync(),
      quality: 100,
      name: "${DateTime.now().millisecondsSinceEpoch}",
    );

    if (!result.containsKey('isSuccess') || !result['isSuccess']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved to Gallery'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Polaroid Image'),
        actions: [
          TextButton(
            onPressed: () => _savePhoto(context),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child) {
            if (value.currentImage != null) {
              return Image.memory(
                value.currentImage!,
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}