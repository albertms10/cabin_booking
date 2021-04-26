import 'package:flutter/material.dart';

class RadioButtonList extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final int? initialIndex;
  final void Function(int)? onChanged;
  final bool reverse;

  const RadioButtonList({
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
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialIndex ?? 0;
  }

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
                EdgeInsets.only(bottom: i == widget._lastLoopIndex ? 0.0 : 4.0),
            child: TextButton(
              style: ElevatedButton.styleFrom(
                primary: _selectedIndex == i
                    ? theme.colorScheme.secondaryVariant
                    : null,
                onPrimary: _selectedIndex == i ? Colors.white : theme.hintColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
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
