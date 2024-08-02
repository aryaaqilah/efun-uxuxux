import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

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
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 100,
        color: const Color(0xFFF4F4F4),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _bottomBarItem(
                  'assets/images/white_frame.png',
                  'White',
                  onPress: () {
                    setState(() {
                      _overlayImagePath =
                          (_overlayImagePath == 'assets/images/white_frame.png')
                              ? null
                              : 'assets/images/white_frame.png';
                    });
                  },
                ),
                _bottomBarItem(
                  'assets/images/black_frame.png',
                  'Black',
                  onPress: () {
                    setState(() {
                      _overlayImagePath =
                          (_overlayImagePath == 'assets/images/black_frame.png')
                              ? null
                              : 'assets/images/black_frame.png';
                    });
                  },
                ),
                _bottomBarItem(
                  'assets/images/blue_frame.png',
                  'Blue',
                  onPress: () {
                    setState(() {
                      _overlayImagePath =
                          (_overlayImagePath == 'assets/images/blue_frame.png')
                              ? null
                              : 'assets/images/blue_frame.png';
                    });
                  },
                ),
                _bottomBarItem(
                  'assets/images/pink_frame.png',
                  'Pink',
                  onPress: () {
                    setState(() {
                      _overlayImagePath =
                          (_overlayImagePath == 'assets/images/pink_frame.png')
                              ? null
                              : 'assets/images/pink_frame.png';
                    });
                  },
                ),
                _bottomBarItem(
                  'assets/images/mint_frame.png',
                  'Mint',
                  onPress: () {
                    setState(() {
                      _overlayImagePath =
                          (_overlayImagePath == 'assets/images/mint_frame.png')
                              ? null
                              : 'assets/images/mint_frame.png';
                    });
                  },
                ),
                _bottomBarItem(
                  'assets/images/yellow_frame.png',
                  'Yellow',
                  onPress: () {
                    setState(() {
                      _overlayImagePath =
                          (_overlayImagePath == 'assets/images/yellow_frame.png')
                              ? null
                              : 'assets/images/yellow_frame.png';
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _bottomBarItem(String imagePath, String label,
    {required VoidCallback onPress}) {
  return GestureDetector(
    onTap: onPress,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 50,
            height: 60,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}