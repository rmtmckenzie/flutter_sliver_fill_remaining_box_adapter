library sliver_fill_remaining_box_adapter;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverFillRemainingBoxAdapter extends SingleChildRenderObjectWidget {
  const SliverFillRemainingBoxAdapter({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  RenderSliverFillRemainingBoxAdapter createRenderObject(BuildContext context) {
    var scrollable = context.ancestorStateOfType(TypeMatcher<ScrollableState>()) as ScrollableState;
    return RenderSliverFillRemainingBoxAdapter(scrollable.widget.controller);
  }
}

class RenderSliverFillRemainingBoxAdapter extends RenderSliverSingleBoxAdapter {
  ScrollController scrollController;

  RenderSliverFillRemainingBoxAdapter(
    this.scrollController, {
    RenderBox child,
  }) : super(child: child);

  double sizeChildNoConstraints() {
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);

    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child.size.width;
        break;
      case Axis.vertical:
        childExtent = child.size.height;
        break;
    }
    assert(childExtent != null);
    return childExtent;
  }

  double sizeChildWithMin(double minExtent) {
    child.layout(constraints.asBoxConstraints(minExtent: minExtent), parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child.size.width;
        break;
      case Axis.vertical:
        childExtent = child.size.height;
        break;
    }
    assert(childExtent != null);
    return childExtent;
  }

  @override
  void performLayout() {
    double extent = constraints.remainingPaintExtent - math.min(constraints.overlap, 0.0);

    if (child == null) {
      // this probably isn't needed, but fills remaining viewport when
      double paintedSize;
      if (scrollController.offset < constraints.viewportMainAxisExtent) {
        paintedSize = constraints.remainingPaintExtent - scrollController.offset;
      } else {
        paintedSize = 0.0;
      }

      geometry = SliverGeometry(
        scrollExtent: extent,
        paintExtent: paintedSize,
        maxPaintExtent: paintedSize,
        hasVisualOverflow: extent > constraints.remainingPaintExtent || constraints.scrollOffset > 0,
      );
      return;
    }

    double childExtent = sizeChildNoConstraints();

    if (scrollController.offset + childExtent < constraints.viewportMainAxisExtent) {
      childExtent = sizeChildWithMin(math.max(childExtent, constraints.remainingPaintExtent - scrollController.offset));
    }

    final double paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent = calculateCacheOffset(constraints, from: 0.0, to: childExtent);
    final bool hasVisualOverflow = childExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0;

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: hasVisualOverflow,
    );
    setChildParentData(child, constraints, geometry);
  }
}
