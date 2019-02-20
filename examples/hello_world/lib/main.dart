// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//void main() => runApp(const Center(child: Text('Hello, world!', textDirection: TextDirection.ltr)));

void main() {
  runApp(const TestWidget());
}

class TestWidget extends StatefulWidget {
  const TestWidget();

  @override
  TestWidgetState createState() => TestWidgetState();
}

class TestWidgetState extends State<TestWidget> {

  double radius = 85.0;
  double width = 200.0;
  double height = 200.0;

  final double max = 200.0;

  RoundedRectCornerMode mode = RoundedRectCornerMode.dynamicShape;
  bool isRoundedCornerMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(40.0) + const EdgeInsets.only(top: 30.0),
              height: 350,
              alignment: Alignment.center,
              child: Material(
                elevation: 20.0,
                color: Colors.lightBlue,
                shape: CupertinoRoundedRectangleBorder(
                  borderRadius: radius,
                  mode: mode,
                ),
                child: Container(
                  width: width,
                  height: height,
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Text('Radius: ' + radius.toString()),
                  CupertinoSlider(
                    min: 0,
                    max: 85,
                    value: radius,
                    onChanged: (double value) {
                       setState(() {
                         radius = value;
                       });
                    }
                  ),
                  Text('Width: ' + width.toString()),
                  CupertinoSlider(
                    max: max,
                    min: 0,
                    value: width,
                    onChanged: (double value) {
                      setState(() {
                        width = value;
                      });
                    }
                  ),
                  Text('Height: ' + height.toString()),
                  CupertinoSlider(
                    max: max,
                    min: 0,
                    value: height,
                    onChanged: (double value) {
                      setState(() {
                        height = value;
                        print(height);
                      });
                    }
                  ),
                  Container(
                    height: 120,
                    child: CupertinoPicker(
                      backgroundColor: Colors.white12,
                      itemExtent: 30,
                      children: const <Widget>[
                        Text('Dynamic Shape'),
                        Text('Dynamic Radius'),
                      ],
                      onSelectedItemChanged: (int item) {
                        setState(() {
                          mode = item == 0 ? RoundedRectCornerMode.dynamicShape :
                            RoundedRectCornerMode.dynamicRadius;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}