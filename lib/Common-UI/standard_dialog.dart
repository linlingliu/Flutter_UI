
import 'package:flutter/material.dart';

class StandardDialog extends StatelessWidget {
  final String title;
  final String content;
  final bool showCancel;
  final String? cancelText;
  final String? confirmText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const StandardDialog({super.key, required this.title, required this.content, this.showCancel = true, this.cancelText, this.confirmText, this.onCancel, this.onConfirm,
  });

  static Future<void> show({required BuildContext context,required String title, required String content, bool showCancel = true,
    String? cancelText, String? confirmText, VoidCallback? onCancel, VoidCallback? onConfirm
  }) {
    return showDialog(context: context, builder: (context) =>
        StandardDialog(
          title: title,
          content: content,
          showCancel: showCancel,
          cancelText: cancelText,
          confirmText: confirmText,
          onCancel: onCancel,
          onConfirm: onConfirm,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
            const SizedBox(height: 16),
            Text(content, style: TextStyle(color: Colors.black54),textAlign: TextAlign.center,),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: showCancel? MainAxisAlignment.spaceBetween: MainAxisAlignment.end,
              children: [
                if (showCancel)
                  Expanded(child: _buildCacnelButtom(context)),
                if (showCancel)
                  const SizedBox(width: 12,),
                Expanded(child: _buildConfirmButtom(context))

              ],
            )
          ],
        ),
      )
    );
  }

  Widget _buildCacnelButtom(BuildContext context) {
    return OutlinedButton(onPressed: () {
      Navigator.of(context).pop();
      onCancel?.call();
    }, style: OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24)
      ),
      side: BorderSide(color: Colors.grey)
    ), child: Text(
      cancelText?? '取消',
      style: TextStyle(color: Colors.black),
    ));
  }

  Widget _buildConfirmButtom(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        onConfirm?.call();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Text(
        confirmText ?? '确定',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

}
