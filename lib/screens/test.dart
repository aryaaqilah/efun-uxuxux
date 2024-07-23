import 'dart:io';

import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      'Choose Layout',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 200,
                    width: 150,
                    color: Colors.cyan,
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Container(
                    height: 200,
                    width: 150,
                    color: Colors.cyan,
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 200,
                    width: 150,
                    color: Colors.cyan,
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Container(
                    height: 200,
                    width: 150,
                    color: Colors.cyan,
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          Icon(
                            Icons.arrow_right,
                            color: Colors.white,
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
      )),
    );
  }
}
