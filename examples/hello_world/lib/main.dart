// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

//void main() => runApp(const Center(child: Text('Hello, world!', textDirection: TextDirection.ltr)));
void main() {
  runApp(SliderDemo());
}

class SliderDemo extends StatefulWidget {
  static const String routeName = '/material/slider';

  @override
  _SliderDemoState createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {

  double radius = 40.0;

  final double min = 0.1;
  final double max = 200;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child:Padding(padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Material(
                  elevation: 20.0,
                  color: Colors.lightBlueAccent,
                  shape: SuperellipseShape(
                    borderRadius: BorderRadius.all(Radius.circular(radius)),
                  ),
                  child: Container(
                    width: 200.0,
                    height: 200.0,
                  ),
                ),
              ),
              Slider(
                value: radius,
                min: min,
                max: max,
                onChanged:(double value) {
                  setState(() {
                    radius = value;
                  });
                },
              ),
            ],
          ),
        )
      ),
    );
  }
}