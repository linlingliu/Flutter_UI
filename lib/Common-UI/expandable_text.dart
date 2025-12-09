import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final bool canPackUp;
  final TextStyle? contentTextStyle;
  final TextStyle? expandedTextStyle;
  final String expandedText;
  final String collapseText;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.canPackUp = true,
    this.contentTextStyle,
    this.expandedTextStyle,
    this.expandedText = '展开',
    this.collapseText = '收起',
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;

  TextStyle get contentStyle => widget.contentTextStyle ?? const TextStyle(fontSize: 16);
  TextStyle get expandStyle => widget.expandedTextStyle ?? const TextStyle(fontSize: 16, color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final maxWidth = size.maxWidth.isFinite ? size.maxWidth : MediaQuery.of(context).size.width;
      // 判断是否溢出
      final painter = _painter(widget.text, maxWidth);
      if (!painter.didExceedMaxLines) {
        return Text(widget.text, style: contentStyle);
      }

      final cutText = _cutText(maxWidth);

      return GestureDetector(
        onTap: () => setState(() => expanded = !expanded),
        child: Text.rich(
          TextSpan(
            style: contentStyle,
            children: [
              TextSpan(text: expanded ? widget.text : cutText),
              TextSpan(text: expanded ? ' ' : '... '),
              TextSpan(
                text: expanded ? widget.collapseText : widget.expandedText,
                style: expandStyle,
              ),
            ],
          ),
          maxLines: expanded ? null : widget.maxLines,
          softWrap: true,
        ),
      );
    });
  }

  /// 按 maxWidth 截断文本（支持中文 + emoji）
  String _cutText(double maxWidth) {
    final runes = widget.text.runes.toList();
    final expandRunesLen = widget.expandedText.runes.length;
    int low = 0, high = runes.length;

    while (low < high) {
      final mid = (low + high) >> 1;
      if (_exceeds(maxWidth, runes, mid)) {
        high = mid;
      } else {
        low = mid + 1;
      }
    }

    // 预留“展开”文案长度 + 1 字符的缓冲，确保按钮文字完整同行显示
    final end = (low - expandRunesLen - 1).clamp(0, runes.length);
    return String.fromCharCodes(runes.sublist(0, end));
  }

  /// 测试给定长度是否超出
  bool _exceeds(double maxWidth, List<int> runes, int takeCount) {
    final candidate = String.fromCharCodes(runes.sublist(0, takeCount));
    final span = TextSpan(
      style: contentStyle,
      children: [
        TextSpan(text: candidate),
        const TextSpan(text: "... "),
        TextSpan(text: widget.expandedText, style: expandStyle),
      ],
    );

    final painter = TextPainter(
      text: span,
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return painter.didExceedMaxLines;
  }

  TextPainter _painter(String text, double maxWidth) {
    return TextPainter(
      text: TextSpan(text: text, style: contentStyle),
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
  }
}
