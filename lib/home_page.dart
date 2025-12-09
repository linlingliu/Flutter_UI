import 'package:common_ui/Common-UI/expandable_text.dart';
import 'package:common_ui/Common-UI/title_value_row.dart';
import 'package:common_ui/Common-UI/empth_content.dart';
import 'package:flutter/material.dart';
import 'Package:common_ui/Common-UI/checkbox.dart';

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

          Spacer()
        ],
      ),
    );
  }
}
