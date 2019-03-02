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
  double borderRadius = 20.0;
  double width = 200.0;
  double height = 200.0;

  final double max = 200.0;

  bool useBorder = true;

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
                shape: ContinuousRectangleBorder(
                  cornerRadius: radius,
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
                  CupertinoButton(
                    child: Text('Switch Border'),
                    onPressed: (){
                      setState(() {
                        useBorder = !useBorder;
                      });
                    },
                  ),
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
                  Text('BorderRadius: ' + borderRadius.toString()),
                  CupertinoSlider(
                      min: 0,
                      max: 85,
                      value: borderRadius,
                      onChanged: (double value) {
                        setState(() {
                          borderRadius = value;
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
                        });
                      }
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