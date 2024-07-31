import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/helper/app_image_picker.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class SelectedCard3x1Page extends StatefulWidget {
  final int cardIndex;

  SelectedCard3x1Page({required this.cardIndex});

  @override
  _SelectedCard3x1PageState createState() => _SelectedCard3x1PageState();
}

class _SelectedCard3x1PageState extends State<SelectedCard3x1Page> {
  late AppImageProvider imageProvider;
  List<File?> images = [null, null, null];

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

  Future<File> _createPolaroidImage() async {
    final img.Image canvas = img.Image(400, 500);
    img.fill(
        canvas, img.getColor(255, 255, 255)); // Fill canvas with white color

    for (int i = 0; i < images.length; i++) {
      if (images[i] != null) {
        img.Image userImage = img.decodeImage(images[i]!.readAsBytesSync())!;

        int targetWidth = 283;
        int targetHeight = 110;

        double imageAspectRatio = userImage.width / userImage.height;
        double targetAspectRatio = targetWidth / targetHeight;

        int cropWidth, cropHeight;

        if (imageAspectRatio > targetAspectRatio) {
          // Gambar lebih lebar daripada target
          cropHeight = userImage.height;
          cropWidth = (cropHeight * targetAspectRatio).round();
        } else {
          // Gambar lebih tinggi daripada target
          cropWidth = userImage.width;
          cropHeight = (cropWidth / targetAspectRatio).round();
        }

        int x = (userImage.width - cropWidth) ~/ 2;
        int y = (userImage.height - cropHeight) ~/ 2;

        // Potong gambar
        img.Image croppedImage =
            img.copyCrop(userImage, x, y, cropWidth, cropHeight);

        // Resize gambar yang dipotong
        img.Image resizedImage = img.copyResize(croppedImage,
            width: targetWidth, height: targetHeight);

        img.copyInto(
          canvas,
          resizedImage,
          dstX: 58,
          dstY: i * 190, // Adjust positioning as needed
          blend: false,
        );
      }
    }

    final Directory tempDir = Directory.systemTemp;
    final File file = File(
        '${tempDir.path}/polaroid_${DateTime.now().millisecondsSinceEpoch}.jpg');
    file.writeAsBytesSync(img.encodeJpg(canvas));

    return file;
  }

  void _goToNextPage(BuildContext context) async {
    File polaroidImage = await _createPolaroidImage();
    imageProvider.changeImageFile(polaroidImage);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DisplayImagePage(
            imageFile: polaroidImage, imageProvider: imageProvider)));
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
            onPressed: () => _goToNextPage(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
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
                                          icon: Icon(Icons.add_photo_alternate),
                                          color: Colors.red,
                                          onPressed: () => _pickImage(
                                              i, ImageSource.gallery),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.camera_alt),
                                          color: Colors.blue,
                                          onPressed: () =>
                                              _pickImage(i, ImageSource.camera),
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
      body:
          // Center(
          //   child: Container(
          //     width: 400,
          //     height: 500,
          //     child: Image.file(
          //       imageFile,
          //       fit: BoxFit.cover, // Agar gambar tidak stretch
          //     ),
          //   ),
          // ),
          Center(
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
