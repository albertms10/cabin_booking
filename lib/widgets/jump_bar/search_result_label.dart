import 'package:flutter/material.dart';

class SearchResultLabel<T> extends StatelessWidget {
  final T? label;
  final String Function(T)? formatter;
  final String placeholder;

  const SearchResultLabel({
    super.key,
    this.label,
    this.formatter,
    this.placeholder = '—',
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelMedium;

    return Text(
      label != null ? '${formatter?.call(label as T) ?? label}' : placeholder,
      style: label != null
          ? textStyle
          : textStyle?.copyWith(color: textStyle.color?.withOpacity(0.6)),
    );
  }
}
