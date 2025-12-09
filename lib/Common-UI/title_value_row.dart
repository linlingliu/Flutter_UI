
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TitleValueRow extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final Function? titlaAction;
  final Function? valueAction;
  final Icons? valueIcon;
  final double horizontalPadding;
  final double verticalPadding;

  const TitleValueRow({
    super.key,
    required this.title,
    required this.value,
    this.titleStyle,
    this.valueStyle,
    this.titlaAction,
    this.valueAction,
    this.valueIcon,
    this.horizontalPadding = 12.0,
    this.verticalPadding = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = const TextStyle(fontSize: 16);

    return Padding(padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(onTap: () => titlaAction,
              child: Text(
                title,
                style: titleStyle ?? defaultStyle,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          SizedBox(width: 8,),
          Expanded(
            child: GestureDetector(
              onTap: () => valueAction,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: valueStyle ?? defaultStyle,
                    textAlign: TextAlign.end,
                  ),
                  if (valueIcon != null)
                    Padding(padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.copy,
                        size: 16
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}