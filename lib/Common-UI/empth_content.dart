import 'package:flutter/material.dart';

class EmpthContent extends StatelessWidget {

  final double paddingTop;
  final double paddingBottom;
  final double imageWidth;
  final String text;
  final String? imagePath;

  const EmpthContent({super.key, this.paddingTop = 30.0, this.paddingBottom = 0.0, this.imageWidth = 130, this.text = '暂无数据', this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(_getImagePath(),width: imageWidth,),
          SizedBox(height: 8,),
          Text(text, style: TextStyle(fontSize: 12),)
        ],
      ),
      ),
    );
  }

  String _getImagePath() {
    return imagePath?? '';
  }
}

