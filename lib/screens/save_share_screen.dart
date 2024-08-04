import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'dart:io';

class SaveShareScreen extends StatefulWidget {
  const SaveShareScreen({Key? key}) : super(key: key);

  @override
  State<SaveShareScreen> createState() => _SaveShareScreenState();
}

class _SaveShareScreenState extends State<SaveShareScreen> {
  String? _overlayImagePath;

  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F4F4),
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.of(context).pushReplacementNamed('/sticker');
          },
        ),
        title: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child) {
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Save n Share',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.of(context).pushReplacementNamed('/history');
              },
              icon: const Icon(Icons.close))
        ],
      ),
      body: Container(
        color: const Color(0xFFD9D9D9),
        child: Center(
          child: Consumer<AppImageProvider>(
            builder: (BuildContext context, value, Widget? child) {
              return value.currentImage != null
                  ? Image.memory(value.currentImage!)
                  : const CircularProgressIndicator();
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Save',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Share',
          ),
        ],
        onTap: (index) async {
          if (index == 0) {
            // Save functionality
            await _saveImage();
          } else if (index == 1) {
            // Share functionality
            await _shareImage();
          }
        },
      ),
    );
  }

  Future<void> _saveImage() async {
    final image = await screenshotController.capture();
    if (image != null) {
      final result = await ImageGallerySaver.saveImage(image);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(result['isSuccess'] ? 'Image Saved!' : 'Save Failed')),
      );
    }
  }

  Future<void> _shareImage() async {
    final image = await screenshotController.capture();
    if (image != null) {
      final directory = (await getApplicationDocumentsDirectory()).path;
      final imagePath = await File('$directory/screenshot.png').create();
      await imagePath.writeAsBytes(image);

      Share.shareFiles([imagePath.path], text: 'Check out this image!');
    }
  }
}
