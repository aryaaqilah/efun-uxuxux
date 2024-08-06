import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class SaveShareScreen extends StatefulWidget {
  const SaveShareScreen({Key? key}) : super(key: key);

  @override
  State<SaveShareScreen> createState() => _SaveShareScreenState();
}

class _SaveShareScreenState extends State<SaveShareScreen> {

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
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
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
          child: Screenshot(
            controller: screenshotController,
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return value.currentImage != null
                    ? Image.memory(value.currentImage!)
                    : const CircularProgressIndicator();
              },
            ),
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
            await _saveImage(context);
          } else if (index == 1) {
            // Share functionality
            await _shareImage();
          }
        },
      ),
    );
  }

  Future<void> _saveImage(BuildContext context) async {
    // Request storage permissions
    var status = await Permission.storage.request();
    print(status);
    if (status.isGranted) {
      try {
        // Capture the screenshot
        final Uint8List? image = await screenshotController.capture();
        if (image != null) {
          // Save the image to the gallery
          final result = await ImageGallerySaver.saveImage(
            image,
            quality: 60,
            name: 'polaroid_${DateTime.now().millisecondsSinceEpoch}',
          );
          if (result['isSuccess']) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Screenshot saved to gallery')),
            );
            // Optionally, update the image provider if necessary
            final directory = (await getApplicationDocumentsDirectory()).path;
            String fileName =
                'polaroid_${DateTime.now().millisecondsSinceEpoch}.jpg';
            String filePath = '$directory/$fileName';
            final File imageFile = File(filePath);
            await imageFile.writeAsBytes(image);
            imageProvider.changeImageFile(imageFile);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Failed to save screenshot to gallery')),
            );
          }
        }
      } catch (e) {
        print('Error saving screenshot: $e');
      }
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Storage permission denied')),
      // );
      try {
        // Capture the screenshot
        final Uint8List? image = await screenshotController.capture();
        if (image != null) {
          // Save the image to the gallery
          final result = await ImageGallerySaver.saveImage(
            image,
            quality: 60,
            name: 'polaroid_${DateTime.now().millisecondsSinceEpoch}',
          );
          if (result['isSuccess']) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image saved to gallery')),
            );
            // Optionally, update the image provider if necessary
            final directory = (await getApplicationDocumentsDirectory()).path;
            String fileName =
                'polaroid_${DateTime.now().millisecondsSinceEpoch}.jpg';
            String filePath = '$directory/$fileName';
            final File imageFile = File(filePath);
            await imageFile.writeAsBytes(image);
            imageProvider.changeImageFile(imageFile);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Failed to save screenshot to gallery')),
            );
          }
        }
      } catch (e) {
        print('Error saving screenshot: $e');
      }
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
