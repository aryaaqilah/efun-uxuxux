import 'package:flutter/material.dart';
import 'package:photo_editor/main.dart';
import 'package:photo_editor/screens/choose_image_1x1_screen.dart';
import 'package:photo_editor/screens/choose_image_2x2_screen.dart';
import 'package:photo_editor/screens/choose_image_3x1_screen.dart';
import 'package:photo_editor/screens/choose_image_3x2_screen.dart';

class ChooseLayout extends StatefulWidget {
  const ChooseLayout({super.key});

  @override
  State<ChooseLayout> createState() => _ChooseLayoutState();
}

class _ChooseLayoutState extends State<ChooseLayout> {
  int _selectedCardIndex = -1;

  void _onCardTap(int index) {
    setState(() {
      _selectedCardIndex = index;
    });
  }

  void _onNextPressed() {
    if (_selectedCardIndex != -1) {
      if (_selectedCardIndex == 1) {
        chosenIndex = 2;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SelectedCard3x1Page(cardIndex: _selectedCardIndex),
          ),
        );
      } else if (_selectedCardIndex == 0) {
        chosenIndex = 1;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SelectedCard1x1Page(cardIndex: _selectedCardIndex),
          ),
        );
      } else if (_selectedCardIndex == 2) {
        chosenIndex = 3;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SelectedCard2x2Page(cardIndex: _selectedCardIndex),
          ),
        );
      } else if (_selectedCardIndex == 3) {
        chosenIndex = 4;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SelectedCard3x2Page(cardIndex: _selectedCardIndex),
          ),
        );
      }
    }
  }

  String _setImage(int index) {
    switch (index) {
      case 0:
        return "assets/layout/layout1x1.png";
      case 1:
        return "assets/layout/layout1x3.png";
      case 2:
        return "assets/layout/layout2x2.png";
      case 3:
        return "assets/layout/layout2x3.png";
      default:
        return "assets/layout/layout1x1.png";
    }
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
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/start');
            }),
        title: const Text(
          'Choose Layout',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 30),
                //   child: Row(
                //     children: [
                //       Text(
                //         'Choose Layout',
                //         style:
                //             TextStyle(color: Color(0xff292929), fontSize: 20),
                //       )
                //     ],
                //   ),
                // ),
                Container(
                  height: MediaQuery.of(context).size.height / 2 + 170,
                  child: GridView.count(
                    childAspectRatio: 0.7,
                    crossAxisCount: 2,
                    children: List.generate(4, (index) {
                      return Container(
                        child: GestureDetector(
                          onTap: () => _onCardTap(index),
                          child: Card(
                            color: _selectedCardIndex == index
                                ? Color(0xff292929)
                                : Colors.white,
                            child: Container(
                                height: 200, // Set height of the card
                                child: Image.asset(_setImage(index))
                                // Center(
                                //   child: Image.asset(_setImage(index)),
                                // ),
                                ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: _onNextPressed,
                        child: Row(
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                  color: Color(0xff292929), fontSize: 15),
                            ),
                            Icon(
                              Icons.arrow_right,
                              color: Color(0xff292929),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
