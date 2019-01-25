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

  double _clampToShortest(RRect rrect, double value) {
    return value > rrect.shortestSide ? rrect.shortestSide : value;
  }

//  Path _getPath(RRect rrect) {
//    final double left = rrect.left;
//    final double right = rrect.right;
//    final double top = rrect.top;
//    final double bottom = rrect.bottom;
//    //  Radii will be clamped to the value of the shortest side
//    /// of [rrect] to avoid strange tie-fighter shapes.
//    final double tlRadiusX =
//      math.max(0.0, _clampToShortest(rrect, rrect.tlRadiusX));
//    final double tlRadiusY =
//      math.max(0.0, _clampToShortest(rrect, rrect.tlRadiusY));
//    final double trRadiusX =
//      math.max(0.0, _clampToShortest(rrect, rrect.trRadiusX));
//    final double trRadiusY =
//      math.max(0.0, _clampToShortest(rrect, rrect.trRadiusY));
//    final double blRadiusX =
//      math.max(0.0, _clampToShortest(rrect, rrect.blRadiusX));
//    final double blRadiusY =
//      math.max(0.0, _clampToShortest(rrect, rrect.blRadiusY));
//    final double brRadiusX =
//      math.max(0.0, _clampToShortest(rrect, rrect.brRadiusX));
//    final double brRadiusY =
//      math.max(0.0, _clampToShortest(rrect, rrect.brRadiusY));
//
//    return Path()
//      ..moveTo(left, top + tlRadiusX)
//      ..cubicTo(left, top, left, top, left + tlRadiusY, top)
//      ..lineTo(right - trRadiusX, top)
//      ..cubicTo(right, top, right, top, right, top + trRadiusY)
//      ..lineTo(right, bottom - blRadiusX)
//      ..cubicTo(right, bottom, right, bottom, right - blRadiusY, bottom)
//      ..lineTo(left + brRadiusX, bottom)
//      ..cubicTo(left, bottom, left, bottom, left, bottom - brRadiusY)
//      ..close();
//  }

  Path _getPath(RRect rrect) {

    final double radius = rrect.trRadiusX;
    final double limit = math.min(rrect.width, rrect.height) / 2 / 1.52866483;
    final double limitedRadius = math.min(radius, limit);


    Offset _topLeft(double x, double y) {
      return Offset(rrect.center.dx + x * limitedRadius, rrect.center.dy + y * limitedRadius);
    }

    Offset _topRight(double x, double y) {
      return Offset(rrect.center.dx - x * limitedRadius + rrect.width, rrect.center.dy + y * limitedRadius);
    }

    Offset _bottomRight(double x, double y) {
      return Offset(rrect.center.dx - x * limitedRadius + rrect.width, rrect.center.dy - y * limitedRadius + rrect.height);
    }

    Offset _bottomLeft(double x, double y) {
      return Offset(rrect.center.dx + x * limitedRadius, rrect.center.dy - y * limitedRadius + rrect.height);
    }

    final Offset p1 = _topLeft(1.52866483, 0.00000000);
    final Offset p1a = _topRight(1.52866471, 0.00000000);

    final Offset p2 = _topRight(0.66993427, 0.06549600);
    final Offset p2a = _topRight(1.08849323, 0.00000000);
    final Offset p2b = _topRight(0.86840689, 0.00000000);

    final Offset p3 = _topRight(0.63149399, 0.07491100);

    final Offset p4 = _topRight(0.07491176, 0.63149399);
    final Offset p4a = _topRight(0.37282392, 0.16905899);
    final Offset p4b = _topRight(0.16906013, 0.37282401);

    final Offset p5 = _topRight(0.00000000, 1.52866483);
    final Offset p5a = _topRight(0.00000000, 0.86840701);
    final Offset p5b = _topRight(0.00000000, 1.08849299);

    final Offset p6 = _bottomRight(0.00000000, 1.52866471);

    final Offset p7 = _bottomRight(0.06549569, 0.66993493);
    final Offset p7a = _bottomRight(0.00000000, 1.08849323);
    final Offset p7b = _bottomRight(0.00000000, 0.86840689);

    final Offset p8 = _bottomRight(0.07491111, 0.63149399);

    final Offset p9 = _bottomRight(0.63149399, 0.07491111);
    final Offset p9a = _bottomRight(0.16905883, 0.37282392);
    final Offset p9b = _bottomRight(0.37282392, 0.16905883);

    final Offset p10 = _bottomRight(1.52866471, 0.00000000);
    final Offset p10a = _bottomRight(0.86840689, 0.00000000);
    final Offset p10b = _bottomRight(1.08849323, 0.00000000);

    final Offset p11 = _bottomLeft(1.52866483, 0.00000000);

//    final Offset p6 = _bottomRight(1.52866471, 0.00000000);
//    final Offset p6 = _bottomRight(1.52866471, 0.00000000);
//    final Offset p6 = _bottomRight(1.52866471, 0.00000000);


    return Path()
      ..moveTo(p1.dx, p1.dy)

      ..lineTo(p1a.dx, p1a.dy)
      ..cubicTo(p2a.dx, p2a.dy, p2b.dx, p2b.dy, p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..cubicTo(p4a.dx, p4a.dy, p4b.dx, p4b.dy, p4.dx, p4.dy)
      ..cubicTo(p5a.dx, p5a.dy, p5b.dx, p5b.dy, p5.dx, p5.dy)

      ..lineTo(p6.dx, p6.dy)
      ..cubicTo(p7a.dx, p7a.dy, p7b.dx, p7b.dy, p7.dx, p7.dy)
      ..lineTo(p8.dx, p8.dy)
      ..cubicTo(p9a.dx, p9a.dy, p9b.dx, p9b.dy, p9.dx, p9.dy)
      ..cubicTo(p10a.dx, p10a.dy, p10b.dx, p10b.dy, p10.dx, p10.dy)

      ..lineTo(p11.dx, p11.dy)

//      [path addLineToPoint: TOP_RIGHT(1.52866471, 0.00000000)];

//      [path addCurveToPoint: TOP_RIGHT(0.66993427, 0.06549600)
//      controlPoint1: TOP_RIGHT(1.08849323, 0.00000000)
//      controlPoint2: TOP_RIGHT(0.86840689, 0.00000000)];

//      [path addLineToPoint: TOP_RIGHT(0.63149399, 0.07491100)];

//      [path addCurveToPoint: TOP_RIGHT(0.07491176, 0.63149399)
//      controlPoint1: TOP_RIGHT(0.37282392, 0.16905899)
//      controlPoint2: TOP_RIGHT(0.16906013, 0.37282401)];

//      [path addCurveToPoint: TOP_RIGHT(0.00000000, 1.52866483)
//      controlPoint1: TOP_RIGHT(0.00000000, 0.86840701)
//      controlPoint2: TOP_RIGHT(0.00000000, 1.08849299)];

//      [path addLineToPoint: BOTTOM_RIGHT(0.00000000, 1.52866471)];

//      [path addCurveToPoint: BOTTOM_RIGHT(0.06549569, 0.66993493)
//      controlPoint1: BOTTOM_RIGHT(0.00000000, 1.08849323)
//      controlPoint2: BOTTOM_RIGHT(0.00000000, 0.86840689)];

//      [path addLineToPoint: BOTTOM_RIGHT(0.07491111, 0.63149399)];

//      [path addCurveToPoint: BOTTOM_RIGHT(0.63149399, 0.07491111)
//      controlPoint1: BOTTOM_RIGHT(0.16905883, 0.37282392)
//      controlPoint2: BOTTOM_RIGHT(0.37282392, 0.16905883)];

//      [path addCurveToPoint: BOTTOM_RIGHT(1.52866471, 0.00000000)
//      controlPoint1: BOTTOM_RIGHT(0.86840689, 0.00000000)
//      controlPoint2: BOTTOM_RIGHT(1.08849323, 0.00000000)];

//      [path addLineToPoint: BOTTOM_LEFT(1.52866483, 0.00000000)];

//      [path addCurveToPoint: BOTTOM_LEFT(0.66993397, 0.06549569)
//      controlPoint1: BOTTOM_LEFT(1.08849299, 0.00000000)
//      controlPoint2: BOTTOM_LEFT(0.86840701, 0.00000000)];
//      [path addLineToPoint: BOTTOM_LEFT(0.63149399, 0.07491111)];
//      [path addCurveToPoint: BOTTOM_LEFT(0.07491100, 0.63149399)
//      controlPoint1: BOTTOM_LEFT(0.37282401, 0.16905883)
//      controlPoint2: BOTTOM_LEFT(0.16906001, 0.37282392)];
//      [path addCurveToPoint: BOTTOM_LEFT(0.00000000, 1.52866471)
//      controlPoint1: BOTTOM_LEFT(0.00000000, 0.86840689)
//      controlPoint2: BOTTOM_LEFT(0.00000000, 1.08849323)];
//      [path addLineToPoint: TOP_LEFT(0.00000000, 1.52866483)];
//      [path addCurveToPoint: TOP_LEFT(0.06549600, 0.66993397)
//      controlPoint1: TOP_LEFT(0.00000000, 1.08849299)
//      controlPoint2: TOP_LEFT(0.00000000, 0.86840701)];
//      [path addLineToPoint: TOP_LEFT(0.07491100, 0.63149399)];
//      [path addCurveToPoint: TOP_LEFT(0.63149399, 0.07491100)
//      controlPoint1: TOP_LEFT(0.16906001, 0.37282401)
//      controlPoint2: TOP_LEFT(0.37282401, 0.16906001)];
//      [path addCurveToPoint: TOP_LEFT(1.52866483, 0.00000000)
//      controlPoint1: TOP_LEFT(0.86840701, 0.00000000)
//      controlPoint2: TOP_LEFT(1.08849299, 0.00000000)];




//      ..moveTo(left, top + tlRadiusX)
//      ..cubicTo(left, top, left, top, left + tlRadiusY, top)
//      ..lineTo(right - trRadiusX, top)
//      ..cubicTo(right, top, right, top, right, top + trRadiusY)
//      ..lineTo(right, bottom - blRadiusX)
//      ..cubicTo(right, bottom, right, bottom, right - blRadiusY, bottom)
//      ..lineTo(left + brRadiusX, bottom)
//      ..cubicTo(left, bottom, left, bottom, left, bottom - brRadiusY)
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