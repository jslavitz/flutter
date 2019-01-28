// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

//void main() => runApp(const Center(child: Text('Hello, world!', textDirection: TextDirection.ltr)));
void main() {

  runApp(CupertinoPickerDemo());

}
class CupertinoPickerDemo extends StatefulWidget {
  @override
  _CupertinoPickerDemoState createState() => _CupertinoPickerDemoState();
}

class _CupertinoPickerDemoState extends State<CupertinoPickerDemo> {

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CupertinoButton(
              child: const Text('Reset Picker'),
              onPressed: () {
                CupertinoDatePicker.reset(context);
              },
            ),
            Container(
                height: 300,
                child:
                CupertinoPicker(
                  itemExtent: 20.0,
                  onSelectedItemChanged: (int v) {

                  },
                  children: const <Widget>[
                    Text('1'),
                    Text('1'),
                    Text('1'),
                    Text('1'),
                    Text('1'),
                    Text('1'),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}