// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
//void main() => runApp(const Center(child: Text('Hello, world!', textDirection: TextDirection.ltr)));
void main() {
  runApp(
      CupertinoApp(
        onGenerateRoute: (RouteSettings settings) {
          return CupertinoPageRoute<void>(
              settings: settings,
              builder: (BuildContext context) {
                final String pageNumber = settings.name == '/' ? '1' : '2';
                return Center(child: Text('Page $pageNumber'));
              }
          );
        },
      )
  );
}