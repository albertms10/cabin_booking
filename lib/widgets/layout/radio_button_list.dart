import 'package:flutter/material.dart';

class RadioButtonList extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final int? initialIndex;
  final void Function(int)? onChanged;
  final bool reverse;

  const RadioButtonList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.initialIndex,
    this.onChanged,
    this.reverse = false,
  });

  int get _initialLoopIndex => reverse ? itemCount - 1 : 0;

  int get _lastLoopIndex => reverse ? 0 : itemCount - 1;

  bool _loopCondition(int index) =>
      reverse ? (index >= 0) : (index < itemCount);

  @override
  _RadioButtonListState createState() => _RadioButtonListState();
}

class _RadioButtonListState extends State<RadioButtonList> {
  late int? _selectedIndex = widget.initialIndex ?? 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        for (var i = widget._initialLoopIndex;
            widget._loopCondition(i);
            widget.reverse ? i-- : i++)
          Padding(
            padding:
                EdgeInsets.only(bottom: i == widget._lastLoopIndex ? 0 : 4),
            child: TextButton(
              style: ElevatedButton.styleFrom(
                foregroundColor:
                    _selectedIndex == i ? Colors.white : theme.hintColor,
                backgroundColor: _selectedIndex == i
                    ? theme.colorScheme.secondaryContainer
                    : null,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
              onPressed: () {
                if (i == _selectedIndex) return;

                setState(() => _selectedIndex = i);
                widget.onChanged?.call(i);
              },
              child: widget.itemBuilder(context, i),
            ),
          ),
      ],
    );
  }
}
