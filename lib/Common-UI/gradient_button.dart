import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    this.colors,
    this.textColor,
    this.splashColor,
    this.disabledTextColor,
    this.disabledColor,
    this.padding,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(2)),
    required this.onPressed, // 1. 修正命名规范
  });

  final List<Color>? colors;
  final Color? textColor;
  final Color? splashColor;
  final Color? disabledTextColor;
  final Color? disabledColor;
  final EdgeInsetsGeometry? padding;
  final Widget child;
  final BorderRadius borderRadius;
  final GestureTapCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDisabled = onPressed == null;

    // 2. 安全地获取颜色列表，仅在非禁用状态下使用
    final List<Color> effectiveColors = isDisabled
        ? []
        : colors ?? [theme.primaryColor, theme.primaryColorDark];

    // 3. 提供更安全、通用的padding默认值
    final EdgeInsetsGeometry effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

    // 4. 集中计算文本样式，避免嵌套和意外覆盖
    final TextStyle effectiveTextStyle = (theme.textTheme.labelMedium ?? const TextStyle()).copyWith(
      color: isDisabled
          ? (disabledTextColor ?? Colors.black38)
          : (textColor ?? Colors.white),
      fontWeight: FontWeight.normal,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        // 5. 确保禁用状态下不创建渐变
        gradient: isDisabled ? null : LinearGradient(colors: effectiveColors),
        color: isDisabled ? (disabledColor ?? theme.disabledColor) : null,
        borderRadius: borderRadius,
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: borderRadius,
        clipBehavior: Clip.hardEdge,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 36.0,
            minWidth: 88.0,
          ),
          child: InkWell(
            // 6. 安全地设置splashColor，禁用状态可为null或特定颜色
            splashColor: isDisabled ? null : (splashColor ?? effectiveColors.last),
            onTap: onPressed,
            child: Padding(
              padding: effectivePadding,
              child: Center(
                // 7. 移除冗余的 DefaultTextStyle 嵌套和 widthFactor/heightFactor
                child: AnimatedDefaultTextStyle(
                  style: effectiveTextStyle,
                  duration: const Duration(milliseconds: 200),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}