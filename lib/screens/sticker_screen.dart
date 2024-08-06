import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:photo_editor/helper/stickers.dart';
import 'package:photo_editor/main.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:text_editor/text_editor.dart';
import 'package:photo_editor/helper/fonts.dart';

class StickerTextScreen extends StatefulWidget {
  const StickerTextScreen({Key? key}) : super(key: key);

  @override
  State<StickerTextScreen> createState() => _StickerTextScreenState();
}

class _StickerTextScreenState extends State<StickerTextScreen> {
  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  LindiController controller = LindiController();
  bool showEditor = false;
  int index = 0;
  int mode = 0; // 0 for stickers, 1 for text

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFF4F4F4),
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            toolbarHeight: 60,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                if (chosenIndex == 1) {
                  Navigator.of(context).pushReplacementNamed('/frame1x1');
                } else if (chosenIndex == 2) {
                  Navigator.of(context).pushReplacementNamed('/frame3x1');
                }
              },
            ),
            title: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add Sticker and Text',
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
                    Uint8List? image = await controller.saveAsUint8List();
                    imageProvider.changeImage(image!);
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
                      child: mode == 0
                          ? ListView.builder(
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
                                              controller.addWidget(Image.asset(
                                                  sticker,
                                                  width: 100));
                                            },
                                            child: Image.asset(sticker),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    showEditor = true;
                                  });
                                },
                                child: const Text(
                                  "Type Here",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _bottomBarItem(
                          0,
                          Icons.emoji_emotions,
                          'Stickers',
                          () {
                            setState(() {
                              mode = 0;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: _bottomBarItem(
                          1,
                          Icons.text_fields,
                          'Text',
                          () {
                            setState(() {
                              mode = 1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showEditor)
          Scaffold(
            backgroundColor: Colors.black.withOpacity(0.85),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextEditor(
                  fonts: Fonts().list(),
                  textStyle: const TextStyle(color: Colors.white),
                  minFontSize: 10,
                  maxFontSize: 70,
                  onEditCompleted: (style, align, text) {
                    setState(() {
                      showEditor = false;
                      if (text.isNotEmpty) {
                        controller.addWidget(
                          Text(
                            text,
                            textAlign: align,
                            style: style,
                          ),
                        );
                      }
                    });
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _bottomBarItem(
      int idx, IconData icon, String label, VoidCallback onPress) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: mode == idx ? Colors.blue : Colors.black,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: mode == idx ? Colors.blue : Colors.black,
              ),
            ),
            Container(
              color: mode == idx ? Colors.blue : Colors.transparent,
              height: 0,
              width: 20,
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
