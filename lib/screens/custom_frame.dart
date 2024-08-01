import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_editor/helper/filters.dart';
import 'package:photo_editor/model/filter.dart';
import 'package:photo_editor/providers/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class ChooseFrameScreen extends StatefulWidget {
  const ChooseFrameScreen({Key? key}) : super(key: key);

  @override
  State<ChooseFrameScreen> createState() => _ChooseFrameScreenState();
}

class _ChooseFrameScreenState extends State<ChooseFrameScreen> {
  late Filter currentFilter;
  late List<Filter> filters;

  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    filters = Filters().list();
    currentFilter = filters[0];
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
            Uint8List? bytes = await screenshotController.capture();
            imageProvider.changeImage(bytes!);
            if (!mounted) return;
            Navigator.of(context).pushReplacementNamed('/filter');
          },
        ),
        title: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    imageProvider.undo();
                  },
                  icon: Icon(Icons.undo,
                      color: value.canUndo ? Colors.black : Colors.grey),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Custom Frame',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    imageProvider.redo();
                  },
                  icon: Icon(Icons.redo,
                      color: value.canRedo ? Colors.black : Colors.grey),
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
                return Screenshot(
                  controller: screenshotController,
                  child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(currentFilter.matrix),
                      child: Image.memory(value.currentImage!)),
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
                              });
                            },
                            child: ColorFiltered(
                              colorFilter: ColorFilter.matrix(filter.matrix),
                              child: Image.memory(value.currentImage!),
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
