// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'basic_types.dart';
import 'border_radius.dart';
import 'borders.dart';
import 'edge_insets.dart';

/// Creates a superellipse - a shape similar to a rounded rectangle, but with
/// a smoother transition from the sides to the rounded corners and greater
/// curve continuity.
///
/// {@tool sample}
/// ```dart
/// Widget build(BuildContext context) {
///   return Material(
///     shape: SuperellipseShape(
///       borderRadius: BorderRadius.circular(28.0),
///     ),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
/// * [RoundedRectangleBorder] Which creates a square with rounded corners,
///   however it doesn't allow the corners to bend the sides of the square
///   like a superellipse, resulting in a more square shape.
class SuperellipseShape extends ShapeBorder {
  /// The arguments must not be null.
  const SuperellipseShape({
    this.side = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
  }) : assert(side != null),
       assert(borderRadius != null);

  /// The radius for each corner.
  ///
  /// Negative radius values are clamped to 0.0 by [getInnerPath] and
  /// [getOuterPath].
  final BorderRadiusGeometry borderRadius;

  /// The style of this border.
  final BorderSide side;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) {
    return SuperellipseShape(
      side: side.scale(t),
      borderRadius: borderRadius * t,
    );
  }

  @override
  ShapeBorder lerpFrom(ShapeBorder a, double t) {
    assert(t != null);
    if (a is SuperellipseShape) {
      return SuperellipseShape(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder lerpTo(ShapeBorder b, double t) {
    assert(t != null);
    if (b is SuperellipseShape) {
      return SuperellipseShape(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t),
      );
    }
    return super.lerpTo(b, t);
  }

  Path _getPath(RRect rrect) {
    final double radius = rrect.trRadiusX;
//    final double limit = math.min(rrect.width, rrect.height) / 2 / 1.52866483;
    final double limitedRadius = radius; //math.min(radius, limit);

    double _leftX(double x) {
      return rrect.center.dx + x * limitedRadius - rrect.width / 2;
    }

    double _rightX(double x) {
      return rrect.center.dx - x * limitedRadius + rrect.width / 2;
    }

    double _topY(double y) {
      return rrect.center.dy + y * limitedRadius - rrect.height / 2;
    }

    double _bottomY(double y) {
      return rrect.center.dy - y * limitedRadius + rrect.height / 2;
    }

    return Path()
      ..moveTo(_leftX(1.52866483), _topY(0))
      ..lineTo(_rightX(1.52866471), _topY(0))
      ..cubicTo(_rightX(1.08849323), _topY(0),
                _rightX(0.86840689), _topY(0),
                _rightX(0.66993427), _topY(0.06549600))
      ..lineTo(_rightX(0.63149399), _topY(0.07491100))
      ..cubicTo(_rightX(0.37282392), _topY(0.16905899),
                _rightX(0.16906013), _topY(0.37282401),
                _rightX(0.07491176), _topY(0.63149399))
      ..cubicTo(_rightX(0), _topY(0.86840701),
                _rightX(0), _topY(1.08849299),
                _rightX(0), _topY(1.52866483))
      ..lineTo(_rightX(0), _bottomY(1.52866471))
      ..cubicTo(_rightX(0), _bottomY(1.08849323),
                _rightX(0), _bottomY(0.86840689),
                _rightX(0.06549600), _bottomY(0.66993427))
      ..lineTo(_rightX(0.07491100), _bottomY(0.63149399))
      ..cubicTo(_rightX(0.16905899), _bottomY(0.37282392),
                _rightX(0.37282401), _bottomY(0.16906013),
                _rightX(0.63149399), _bottomY(0.07491176))
      ..cubicTo(_rightX(0.86840701), _bottomY(0),
                _rightX(1.08849299), _bottomY(0),
                _rightX(1.52866483), _bottomY(0))
      ..lineTo(_leftX(1.52866483), _bottomY(0))
      ..cubicTo(_leftX(1.08849323), _bottomY(0),
                _leftX(0.86840689), _bottomY(0),
                _leftX(0.66993427), _bottomY(0.06549600))
      ..lineTo(_leftX(0.63149399), _bottomY(0.07491100))
      ..cubicTo(_leftX(0.37282392), _bottomY(0.16905899),
                _leftX(0.16906013), _bottomY(0.37282401),
                _leftX(0.07491176), _bottomY(0.63149399))
      ..cubicTo(_leftX(0), _bottomY(0.86840701),
                _leftX(0), _bottomY(1.08849299),
                _leftX(0), _bottomY(1.52866483))
      ..lineTo(_leftX(0), _topY(1.52866471))
      ..cubicTo(_leftX(0), _topY(1.08849323),
                _leftX(0), _topY(0.86840689),
                _leftX(0.06549600), _topY(0.66993427))
      ..lineTo(_leftX(0.07491100), _topY(0.63149399))
      ..cubicTo(_leftX(0.16905899), _topY(0.37282392),
                _leftX(0.37282401), _topY(0.16906013),
                _leftX(0.63149399), _topY(0.07491176))
      ..cubicTo(_leftX(0.86840701), _topY(0),
                _leftX(1.08849299), _topY(0),
                _leftX(1.52866483), _topY(0))
      ..close();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return _getPath(borderRadius.resolve(textDirection).toRRect(rect).deflate(side.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return _getPath(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    if (rect.isEmpty)
      return;
    switch (side.style) {
      case BorderStyle.none:
      break;
      case BorderStyle.solid:
        final Path path = getOuterPath(rect, textDirection: textDirection);
        final Paint paint = side.toPaint();
        canvas.drawPath(path, paint);
        break;
    }
  }

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType)
      return false;
    final SuperellipseShape typedOther = other;
    return side == typedOther.side
        && borderRadius == typedOther.borderRadius;
  }

  @override
  int get hashCode => hashValues(side, borderRadius);

  @override
  String toString() {
    return '$runtimeType($side, $borderRadius)';
  }
}