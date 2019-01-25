// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

//void main() => runApp(const Center(child: Text('Hello, world!', textDirection: TextDirection.ltr)));
void main() {
  runApp(
    MaterialApp(
      home: Container(
        width: 300,
        height: 300,
        alignment: Alignment.center,
        child: Material(
          color: Colors.blueAccent[400],
            shape: SuperellipseShape(
              borderRadius: const BorderRadius.all(Radius.circular(40.0)),
            ),
            child: Container(
              width: 100.0,
              height: 200.0,
            ), // Container
          ), // Material
      ),
    )
  );
}