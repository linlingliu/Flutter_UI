import 'dart:async';

import 'package:flutter/material.dart';

bool isListEqual(List? a, List? b) {
  if (a == b) return true;
  if (a == null || b == null || a.length != b.length) return false;
  int i = 0;
  return a.every((e) => b[i ++] == e);
}

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 400)});

  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  // 新增：允许手动取消
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}