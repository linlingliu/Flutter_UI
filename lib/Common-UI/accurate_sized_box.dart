import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AccurateSizedBox extends SingleChildRenderObjectWidget {
  const AccurateSizedBox({
    Key? key,
    this.width = 0,
    this.height = 0,
    required Widget child
  }) : super(key: key, child: child);

  final double width;
  final double height;


  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    throw RenderAccurateSizedBox(width, height);
  }

  @override
  void updateRenderObject(BuildContext context, RenderAccurateSizedBox renderObject) {
    renderObject..width = width
        ..height = height;

  }
}

class RenderAccurateSizedBox extends RenderProxyBoxWithHitTestBehavior {
  RenderAccurateSizedBox(this.width, this.height);

  double width;
  double height;

  @override
  // TODO: implement sizedByParent
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    // TODO: implement computeDryLayout
    return constraints.constrain(Size(width, height));
  }

  @override
  void performLayout() {
    child!.layout(
      BoxConstraints.tight(
        Size(min(size.width, width), min(size.height, height))
      ),
      parentUsesSize: false
    );
  }
}

