import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Alias for TextAlignVertical.
typedef VerticalAlign = TextAlignVertical;

/// A widget which supports left-right layout algorithm.
class LeftRightBox extends MultiChildRenderObjectWidget {
  LeftRightBox({
    Key? key,
    required Widget left,
    Widget? right,
    this.verticalAlign = VerticalAlign.top,
  }) : super(key: key, children: _buildChildren(left, right));

  final VerticalAlign verticalAlign;

  /// 构建子节点列表，确保逻辑清晰
  static List<Widget> _buildChildren(Widget left, Widget? right) {
    final children = <Widget>[left];
    if (right != null) {
      children.add(right);
    }
    return children;
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderLeftRight(verticalAlign);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderLeftRight renderObject) {
    renderObject.verticalAlign = verticalAlign;
  }
}

class _LeftRightParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderLeftRight extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _LeftRightParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _LeftRightParentData> {
  _RenderLeftRight(this.verticalAlign);

  VerticalAlign verticalAlign;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _LeftRightParentData) {
      child.parentData = _LeftRightParentData();
    }
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;

    // 1. 安全地获取左右子节点
    final leftChild = firstChild!;
    final leftParentData = leftChild.parentData! as _LeftRightParentData;
    final rightChild = leftParentData.nextSibling;

    double rightChildWidth = 0.0;
    double rightChildHeight = 0.0;
    Offset rightChildOffset = Offset.zero;

    // 2. 布局右子节点（如果存在）
    if (rightChild != null) {
      _layoutRightChild(
        rightChild,
        constraints,
        onLayoutDone: (size) {
          rightChildWidth = size.width;
          rightChildHeight = size.height;
          rightChildOffset = Offset(constraints.maxWidth - rightChildWidth, 0);
        },
      );
    }

    // 3. 布局左子节点
    final leftChildSize = _layoutLeftChild(leftChild, constraints, rightChildWidth);

    // 4. 确定容器自身尺寸
    size = Size(
      constraints.maxWidth,
      max(leftChildSize.height, rightChildHeight),
    );

    // 5. 设置子节点偏移量
    _setChildrenOffset(
      leftChild: leftChild,
      rightChild: rightChild,
      rightChildOffset: rightChildOffset,
      containerSize: size,
    );

    // 6. 处理垂直对齐
    if (_shouldApplyVerticalAlignment) {
      _applyVerticalAlignment(
        leftChild: leftChild,
        rightChild: rightChild,
        containerHeight: size.height,
      );
    }
  }

  /// 布局右子节点
  void _layoutRightChild(
      RenderBox child,
      BoxConstraints constraints, {
        required ValueChanged<Size> onLayoutDone,
      }) {
    // 限制右子节点宽度不超过总宽度一半
    child.layout(
      constraints.copyWith(minWidth: 0, maxWidth: constraints.maxWidth / 2),
      parentUsesSize: true, // 需要知道右子节点大小来布局左子节点
    );
    onLayoutDone(child.size);
  }

  /// 布局左子节点
  Size _layoutLeftChild(
      RenderBox child,
      BoxConstraints constraints,
      double rightChildWidth,
      ) {
    // 左子节点获得剩余宽度
    child.layout(
      constraints.copyWith(
        minWidth: 0,
        maxWidth: constraints.maxWidth - rightChildWidth,
      ),
      parentUsesSize: false, // 左子节点大小变化不影响父容器（父容器尺寸已由约束决定）
    );
    return child.size;
  }

  /// 设置子节点基础偏移量
  void _setChildrenOffset({
    required RenderBox leftChild,
    required RenderBox? rightChild,
    required Offset rightChildOffset,
    required Size containerSize,
  }) {
    // 左子节点默认在 (0, 0)
    final leftParentData = leftChild.parentData! as _LeftRightParentData;
    leftParentData.offset = Offset.zero;

    // 右子节点靠右放置
    if (rightChild != null) {
      final rightParentData = rightChild.parentData! as _LeftRightParentData;
      rightParentData.offset = rightChildOffset;
    }
  }

  /// 判断是否需要垂直对齐
  bool get _shouldApplyVerticalAlignment => verticalAlign.y != -1;

  /// 应用垂直对齐
  void _applyVerticalAlignment({
    required RenderBox leftChild,
    required RenderBox? rightChild,
    required double containerHeight,
  }) {
    // 确定哪个子节点需要对齐（高度较小的那个）
    final leftHeight = leftChild.size.height;
    final rightHeight = rightChild?.size.height ?? 0.0;

    RenderBox? childToAlign;
    _LeftRightParentData? parentDataToAlign;

    if (leftHeight < containerHeight) {
      childToAlign = leftChild;
      parentDataToAlign = leftChild.parentData! as _LeftRightParentData;
    } else if (rightChild != null && rightHeight < containerHeight) {
      childToAlign = rightChild;
      parentDataToAlign = rightChild.parentData! as _LeftRightParentData;
    }

    if (childToAlign != null && parentDataToAlign != null) {
      final dy = _calculateVerticalOffset(
        childHeight: childToAlign.size.height,
        containerHeight: containerHeight,
        alignment: verticalAlign,
      );

      parentDataToAlign.offset = Offset(
        parentDataToAlign.offset.dx,
        dy,
      );
    }
  }

  /// 计算垂直偏移量
  double _calculateVerticalOffset({
    required double childHeight,
    required double containerHeight,
    required VerticalAlign alignment,
  }) {
    final heightDifference = containerHeight - childHeight;

    switch (alignment.y) {
      case 0: // center
        return heightDifference / 2;
      case 1: // bottom
        return heightDifference;
      default: // top (should not reach here)
        return 0;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}