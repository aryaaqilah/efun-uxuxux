import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class ChooseFrameScreen extends StatefulWidget {
  const ChooseFrameScreen({Key? key}) : super(key: key);

  @override
  State<ChooseFrameScreen> createState() => _ChooseFrameScreenState();
}

class _ChooseFrameScreenState extends State<ChooseFrameScreen> {
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
            // Uint8List? bytes = await screenshotController.capture();
            // imageProvider.changeImage(bytes!);
            // if (!mounted) return;
            Navigator.of(context).pushReplacementNamed('/filter');
          },
        ),
        title: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child) {
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // IconButton(
                //   onPressed: () {
                //     imageProvider.undo();
                //     setState(() {});
                //   },
                //   icon: Icon(Icons.undo,
                //       color: value.canUndo ? Colors.black : Colors.grey),
                // ),
                // const SizedBox(width: 8),
                Text(
                  'Custom Your Frame',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                // const SizedBox(width: 8),
                // IconButton(
                //   onPressed: () {
                //     imageProvider.redo();
                //     setState(() {});
                //   },
                //   icon: Icon(Icons.redo,
                //       color: value.canRedo ? Colors.black : Colors.grey),
                // ),
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
                Navigator.of(context).pushReplacementNamed('/sticker');
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: Container(
        color: const Color(0xFFD9D9D9),
        child: Center(
          child: Consumer<AppImageProvider>(
            builder: (BuildContext context, value, Widget? child) {
              if (value.currentImage != null) {
                // return overlayImage(
                //   value.currentImage!,
                //   _overlayImagePath ?? '',
                // );
                return Screenshot(
                  controller: screenshotController,
                  child: Stack(
                    children: [
                      Image.memory(value.currentImage!),
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
                      _overlayImagePath = (_overlayImagePath ==
                              'assets/images/yellow_frame.png')
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

// Widget overlayImage(Uint8List imageProviderImage, String overlayAssetPath) {
//   return Stack(
//     children: [
//       Image.memory(imageProviderImage),
//       if (overlayAssetPath.isNotEmpty)
//         Positioned.fill(
//           child: Align(
//             alignment: Alignment.center,
//             child: Image.asset(
//               overlayAssetPath,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//     ],
//   );
// }
