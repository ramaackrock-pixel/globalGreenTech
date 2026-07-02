import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

enum AdaptiveButtonType { filled, text, outlined }

class AdaptiveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final AdaptiveButtonType type;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AdaptiveButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.type = AdaptiveButtonType.filled,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = false; // Always use Material design to match Android design

    if (isIOS) {
      switch (type) {
        case AdaptiveButtonType.filled:
          return CupertinoButton.filled(
            onPressed: onPressed,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: child,
          );
        case AdaptiveButtonType.outlined:
          return CupertinoButton(
            onPressed: onPressed,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.activeBlue),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: child,
            ),
          );
        case AdaptiveButtonType.text:
          return CupertinoButton(
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            child: child,
          );
      }
    } else {
      final btnBg = backgroundColor ?? Theme.of(context).colorScheme.primary;
      final btnFg = foregroundColor ?? Theme.of(context).colorScheme.onPrimary;

      switch (type) {
        case AdaptiveButtonType.filled:
          return ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: btnBg,
              foregroundColor: btnFg,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: child,
          );
        case AdaptiveButtonType.outlined:
          return OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: child,
          );
        case AdaptiveButtonType.text:
          return TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: child,
          );
      }
    }
  }
}

class AdaptiveTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AdaptiveTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = false; // Always use Material design to match Android design
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isIOS) {
      return FormField<String>(
        validator: validator,
        initialValue: controller?.text,
        builder: (FormFieldState<String> state) {
          // Sync text value
          void localOnChanged(String value) {
            state.didChange(value);
            if (onChanged != null) onChanged!(value);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (labelText != null) ...[
                Text(
                  labelText!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkOnSurfaceColor : AppTheme.onSurfaceColor,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CupertinoTextField(
                  controller: controller,
                  placeholder: hintText,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  onChanged: localOnChanged,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  prefix: prefixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: prefixIcon,
                        )
                      : null,
                  suffix: suffixIcon,
                  placeholderStyle: TextStyle(
                    color: isDark ? AppTheme.darkOutlineColor : AppTheme.outlineColor,
                    fontSize: 15,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkSurfaceContainerLowestColor : Colors.white,
                    border: Border.all(
                      color: state.hasError
                          ? AppTheme.errorColor
                          : (isDark ? AppTheme.darkOutlineVariantColor : AppTheme.outlineVariantColor),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  style: TextStyle(
                    color: isDark ? AppTheme.darkOnSurfaceColor : AppTheme.onSurfaceColor,
                    fontSize: 16,
                  ),
                ),
              ),
              if (state.hasError) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    state.errorText!,
                    style: const TextStyle(
                      color: AppTheme.errorColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null) ...[
            Text(
              labelText!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkOnSurfaceColor : AppTheme.onSurfaceColor,
              ),
            ),
            const SizedBox(height: 6),
          ],
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
          ),
        ],
      );
    }
  }
}

class AdaptiveProgressIndicator extends StatelessWidget {
  final double radius;
  final Color? color;

  const AdaptiveProgressIndicator({
    super.key,
    this.radius = 10.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = false; // Always use Material design to match Android design

    if (isIOS) {
      return CupertinoActivityIndicator(radius: radius, color: color);
    } else {
      return CircularProgressIndicator(
        valueColor: color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
      );
    }
  }
}

class AdaptiveDialogAction {
  final String text;
  final VoidCallback onPressed;
  final bool isDestructive;

  const AdaptiveDialogAction({
    required this.text,
    required this.onPressed,
    this.isDestructive = false,
  });
}

class AdaptiveDialog {
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String content,
    required List<AdaptiveDialogAction> actions,
  }) {
    final isIOS = false; // Always use Material design to match Android design

    if (isIOS) {
      return showCupertinoDialog<T>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: actions
                .map(
                  (a) => CupertinoDialogAction(
                    onPressed: a.onPressed,
                    isDestructiveAction: a.isDestructive,
                    child: Text(a.text),
                  ),
                )
                .toList(),
          );
        },
      );
    } else {
      return showDialog<T>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: actions
                .map(
                  (a) => TextButton(
                    onPressed: a.onPressed,
                    style: a.isDestructive
                        ? TextButton.styleFrom(foregroundColor: AppTheme.errorColor)
                        : null,
                    child: Text(a.text),
                  ),
                )
                .toList(),
          );
        },
      );
    }
  }
}
