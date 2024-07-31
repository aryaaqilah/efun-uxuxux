import 'package:flutter/material.dart';

class SelectedCard3x2Page extends StatelessWidget {
  final int cardIndex;

  SelectedCard3x2Page({required this.cardIndex});

  @override
  Widget build(BuildContext context) {
    int index = cardIndex + 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Card Page'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text('You selected card $cardIndex'),
          Container(
            width: 400,
            height: 500,
            child: Image.asset('assets/layout/$index.png'),
            // color: Colors.amber,
          ),
        ],
      )),
    );
  }
}
