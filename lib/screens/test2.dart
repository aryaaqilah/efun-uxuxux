import 'package:flutter/material.dart';

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectedCardPage(cardIndex: _selectedCardIndex),
        ),
      );
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
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      Text(
                        'Choose Layout',
                        style:
                            TextStyle(color: Color(0xff292929), fontSize: 20),
                      )
                    ],
                  ),
                ),
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

class SelectedCardPage extends StatelessWidget {
  final int cardIndex;

  SelectedCardPage({required this.cardIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Card Page'),
      ),
      body: Center(
        child: Text('You selected card $cardIndex'),
      ),
    );
  }
}