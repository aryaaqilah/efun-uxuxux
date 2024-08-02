import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:photo_editor/helper/stickers.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StickerScreen extends StatefulWidget {
  const StickerScreen({Key? key}) : super(key: key);

  @override
  State<StickerScreen> createState() => _StickerScreenState();
}

class _StickerScreenState extends State<StickerScreen> {
  String? _overlayImagePath;

  late AppImageProvider imageProvider;

  ScreenshotController screenshotController = ScreenshotController();
  LindiController controller = LindiController();

  int index = 0;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  Future<void> _captureAndSaveScreenshot(BuildContext context) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    String fileName = 'sticker_${DateTime.now().millisecondsSinceEpoch}.jpg';
    String filePath = '$directory/$fileName';

    screenshotController.capture().then((Uint8List? image) async {
      if (image != null) {
        final File imageFile = File(filePath);
        await imageFile.writeAsBytes(image);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F4F4),
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            Uint8List? bytes = await screenshotController.capture();
            imageProvider.changeImage(bytes!);
            if (!mounted) return;
            Navigator.of(context).pushReplacementNamed('/filter');
          },
        ),
        title: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child) {
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Sticker',
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
                Uint8List? bytes = await screenshotController.capture();
                imageProvider.changeImage(bytes!);
                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed('/save');
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child) {
            if (value.currentImage != null) {
              return Screenshot(
                controller: screenshotController,
                child: Stack(
                  children: [
                    LindiStickerWidget(
                      controller: controller,
                      child: Image.memory(value.currentImage!),
                    ),
                    if (_overlayImagePath != null &&
                        _overlayImagePath!.isNotEmpty)
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            _overlayImagePath!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 100,
        color: const Color(0xFFF4F4F4),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                    color: const Color(0xFFF4F4F4),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Stickers().list()[index].length,
                      itemBuilder: (BuildContext context, int idx) {
                        String sticker = Stickers().list()[index][idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: InkWell(
                                    onTap: () {
                                      controller.addWidget(
                                          Image.asset(sticker, width: 100));
                                    },
                                    child: Image.asset(sticker),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
              ),
              SingleChildScrollView(
                child: Row(
                  children: [
                    for (int i = 0; i < Stickers().list().length; i++)
                      _bottomBatItem(i, Stickers().list()[i][0], onPress: () {
                        setState(() {
                          index = i;
                        });
                      })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBatItem(int idx, String icon,
      {required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                color: index == idx ? Colors.blue : Colors.transparent,
                height: 2,
                width: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(icon, width: 30),
            ),
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
