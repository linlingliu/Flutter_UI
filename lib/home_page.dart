import 'package:common_ui/Common-UI/expandable_text.dart';
import 'package:common_ui/Common-UI/title_value_row.dart';
import 'package:common_ui/Common-UI/empth_content.dart';
import 'package:flutter/material.dart';
import 'Common-UI/highlighted_text.dart';
import 'Package:common_ui/Common-UI/checkbox.dart';
import 'Common-UI/standard_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<bool> flagNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    // 3. 非常重要！页面销毁时，需要释放 ValueNotifier 以避免内存泄漏。
    flagNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("home page")),
      body: Column(
        children: [
          //TitleValueRow(title: "价格", value: "--"),
          //EmpthContent(),
          ExpandableText(text: "textcvhfdhfgdsfasdcsavfdbgfdhbgfnbdfsafdhbgfnbdfsavfdbgfdhbgfnbdsavfdbgfdhbgfnbdfvdscadsadcsefvdgbvfcb xfvdscadsadcsefvdgbvfcb xvdscadsadcsefvdgbvfcb x",
          maxLines: 2,),
          CheckboxTitle(
            flag: flagNotifier,
            title: '同意协议',
            onChanged: (value) {
              print('复选框状态：$value');
            },
          ),
          HighlightedText(
            text: '这是一个包含高亮词的示例文本，点击高亮词有回调',
            hightlights: [
              HighLightWord(
                '高亮词',
                onTap: () => print('点击了高亮词'),
              ),
              HighLightWord(
                '回调',
                onTap: () => print('点击了回调'),
                textStyle: TextStyle(color: Colors.red),
              ),
            ],
            textStyle: TextStyle(fontSize: 16, color: Colors.black),
            hightLightStyle: TextStyle(
              color: Colors.blue,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              StandardDialog.show(
                context: context,
                title: '标准对话框',
                content: '这是一个标准对话框的内容。您可以在这里放置一些文本信息。',
                showCancel: true,
                onCancel: () {
                  print('点击了取消');
                },
                onConfirm: () {
                  print('点击了确定');
                },
              );
            },
            child: const Text('显示标准对话框（带取消）'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              StandardDialog.show(
                context: context,
                title: '提示',
                content: '这是一个只有确定按钮的对话框。',
                showCancel: false,
                onConfirm: () {
                  print('点击了确定');
                },
              );
            },
            child: const Text('显示标准对话框（仅确定）'),
          ),
          Spacer()
        ],
      ),
    );
  }
}
