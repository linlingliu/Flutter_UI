import 'package:flutter/material.dart';

class CheckboxTitle extends StatelessWidget {
  final ValueNotifier<bool> flag;
  final bool isDisable;
  final ValueChanged<bool>? onChanged;
  final String? title;
  final bool undleline;
  final VoidCallback? onTitleTap;

  const CheckboxTitle({super.key, required this.flag, this.isDisable = false, this.onChanged, this.title, this.undleline = false, this.onTitleTap});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(valueListenable: flag, builder: (contxt, value, child) {
      Widget checkboxImage = Image.asset(_getImage(value), width: 20, height: 20,);
      if (title != null) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: isDisable ? null : _handleTap,
              child: checkboxImage,
            ),
            const SizedBox(width: 4,),
            Flexible(
              child: GestureDetector(
                onTap: isDisable ? null : _handleTitleTap,
                child: Text(
                  title ?? '',
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 16,
                    decoration: undleline ? TextDecoration.none: TextDecoration.underline,
                    color: isDisable ? Colors.grey : null,
                  ),
                ),
              ),
            )
          ],
        );
      } else {
        return GestureDetector(
          onTap: isDisable ? null : _handleTap,
          child: checkboxImage,
        );
      }
    });
  }

  void _handleTap() {
    final newValue = !flag.value;
    flag.value = newValue;
    onChanged?.call(newValue);
  }
  void _handleTitleTap() {
    if (onTitleTap == null) {
      _handleTap();
    } else {
      onTitleTap!();
    }


  }

  String _getImage(bool value) {
    if (isDisable) {
      return value
          ? 'lib/assets/selected_disabled.png'
          : 'lib/assets/unselected_disabled.png';
    } else {
      return value ? 'lib/assets/selected.png' : 'lib/assets/unselected.png';
    }
  }
}
