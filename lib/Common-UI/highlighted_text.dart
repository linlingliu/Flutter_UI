import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {

  final String text;
  final List<HighLightWord> hightlights;
  final TextStyle? textStyle;
  final TextStyle? hightLightStyle;
  final int maxLines;
  final TextOverflow overflow;

  // 修正构造函数：使用正确的 super(key: key) 语法
  const HighlightedText({
    Key? key, // 这里接收 key
    required this.text,
    this.hightlights = const [], // 这里使用修正后的变量名
    this.textStyle,
    this.hightLightStyle,
    this.maxLines = 3,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key); // 这里将 key 传递给父类

  @override
  Widget build(BuildContext context) {
    return RichText(text:
    TextSpan(
      children: _buildTextSpans(),
    ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  List<TextSpan> _buildTextSpans() {
    if(hightlights.isEmpty) {
      return [TextSpan(text: text, style: textStyle)];
    }
    List<TextSpan> spans = [];
    int currentIndex = 0;
    List<HighLightWord> sortHighLights = List.from(hightlights)..sort((a,b) => text.indexOf(a.word).compareTo(text.indexOf(b.word)));
    for (var hihtlight in sortHighLights) {
      int startIndex = text.indexOf(hihtlight.word, currentIndex);
      if (startIndex == -1) continue;
      if (startIndex > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, startIndex),
          style: textStyle
        ));
      }
      spans.add(TextSpan(
        text: hihtlight.word,
        style: hihtlight.textStyle ?? hightLightStyle,
        recognizer: hihtlight.onTap != null? (TapGestureRecognizer()..onTap = hihtlight.onTap) : null
      ));
      currentIndex = startIndex + hihtlight.word.length;
    }
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: textStyle
      ));
    }
    return spans;
  }
}

class HighLightWord {
  final String word;
  final VoidCallback? onTap;
  final TextStyle? textStyle;

  HighLightWord(this.word,{this.onTap,this.textStyle});
}
