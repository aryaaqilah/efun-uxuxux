import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_editor/helper/filters.dart';
import 'package:photo_editor/main.dart';
import 'package:photo_editor/model/filter.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:photo_editor/screens/custom_frame3x1.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Filter currentFilter;
  late List<Filter> filters;

  late AppImageProvider imageProvider;
  late int indexOri;
  // late String? frame;
  // late Uint8List originalImage;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    filters = Filters().list();
    currentFilter = filters[0];
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    indexOri = imageProvider.index - 1;
    // frame = widget.frame;
    // originalImage = imageProvider.getImageByIndex(indexOri);
    super.initState();
  }

  // void _applyFilter(ColorFilter filter) async {
  //   Uint8List filteredBytes =
  //       await screenshotController.captureFromWidget(ColorFiltered(
  //     colorFilter: filter,
  //     child: Image.memory(originalImage),
  //   ));
  //   imageProvider.changeImage(filteredBytes);
  // }

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
          onPressed: () {
            // framePath = null;
            Navigator.of(context).pop();
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
                //   },
                //   icon: Icon(Icons.undo,
                //       color: value.canUndo ? Colors.black : Colors.grey),
                // ),
                // const SizedBox(width: 8),
                Text(
                  "Add Filter",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                // const SizedBox(width: 8),
                // IconButton(
                //   onPressed: () {
                //     imageProvider.redo();
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
                if (chosenIndex == 1) {
                  Navigator.of(context).pushNamed('/frame1x1');
                } else if (chosenIndex == 2) {
                  Navigator.of(context).pushNamed('/frame3x1');
                  // final result = await Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const ChooseFrameScreen(),
                  //   ),
                  // ) as String?;

                  // setState(() {
                  //   frame = result;
                  // });
                }
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
                return Screenshot(
                  controller: screenshotController,
                  // child: ColorFiltered(
                  //     colorFilter: ColorFilter.matrix(currentFilter.matrix),
                  //     child: Image.memory(value.getImageByIndex(indexOri)!)),
                  child: Stack(
                    children: [
                      // Apply the filter to the image
                      ColorFiltered(
                        colorFilter: ColorFilter.matrix(currentFilter.matrix),
                        child: Image.memory(value.getImageByIndex(indexOri)!),
                      ),
                      // if (framePath != null && framePath!.isNotEmpty)
                      //   Positioned.fill(
                      //     child: Align(
                      //       alignment: Alignment.center,
                      //       child: Image.asset(
                      //         framePath!,
                      //         fit: BoxFit.contain,
                      //       ),
                      //     ),
                      //   )
                      // else if (framePath == null && frame != null && frame!.isNotEmpty)
                      //   Positioned.fill(
                      //     child: Align(
                      //       alignment: Alignment.center,
                      //       child: Image.asset(
                      //         frame!,
                      //         fit: BoxFit.contain,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            // builder: (BuildContext context, value, Widget? child) {
            //   return value.currentImage != null
            //       ? Image.memory(value.currentImage!)
            //       : const CircularProgressIndicator();
            // },
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 100,
        color: const Color(0xFFF4F4F4),
        child: SafeArea(child: Consumer<AppImageProvider>(
            builder: (BuildContext context, value, Widget? child) {
          return ListView.builder(
            padding: const EdgeInsets.only(left: 5, right: 5),
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            itemBuilder: (BuildContext context, int index) {
              Filter filter = filters[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFD9D9D9),
                          width: 2,
                        ),
                      ),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                currentFilter = filter;
                                // _applyFilter(ColorFilter.matrix(filter.matrix));
                              });
                            },
                            child: ColorFiltered(
                              colorFilter: ColorFilter.matrix(filter.matrix),
                              child: Image.memory(
                                  value.getImageByIndex(indexOri)!),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      filter.filterName,
                      style: const TextStyle(color: Colors.black),
                    )
                  ],
                ),
              );
            },
          );
        })),
      ),
    );
  }
}
