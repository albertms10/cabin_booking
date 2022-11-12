import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/utils/string_extension.dart';
import 'package:collection/collection.dart' show IterableNullableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class JumpBar extends StatefulWidget {
  const JumpBar({super.key});

  @override
  State<JumpBar> createState() => _JumpBarState();
}

class _JumpBarState extends State<JumpBar> {
  final TextEditingController _controller = TextEditingController();

  Booking? _suggestedBooking;

  List get _items => const [1];

  static const double _searchBarHeight = 48.0;
  static const double _itemHeight = 64.0;

  double get _height =>
      _searchBarHeight + _itemHeight + (_items.length * _itemHeight);

  @override
  void initState() {
    super.initState();

    _controller.addListener(_handleInputChange);
  }

  void _handleInputChange() {
    final appLocalizations = AppLocalizations.of(context)!;

    final cabinTokens =
        _controller.text.tokenize(Cabin.tokenExpressions(appLocalizations));

    final cabin = Provider.of<CabinManager>(context, listen: false)
        .findCabinFromTokens(cabinTokens);

    final bookingTokens = {
      ..._controller.text.tokenize(Booking.tokenExpressions(appLocalizations)),
      ..._controller.text
          .tokenize(RecurringBooking.tokenExpressions(appLocalizations)),
    };

    setState(() {
      _suggestedBooking = Booking.fromTokens(bookingTokens, appLocalizations)
          .copyWith(cabinId: cabin?.id);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 200.0,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _height,
              width: 360.0,
              child: Material(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                elevation: 12.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SearchBarField(controller: _controller),
                    if (_items.isNotEmpty) const Divider(height: 0.0),
                    if (_suggestedBooking != null)
                      _SearchBarItem(
                        icon: Icons.auto_awesome,
                        child:
                            _BookingSearchResult(booking: _suggestedBooking!),
                      ),
                    for (final item in _items) const _SearchBarItem(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBarField extends StatelessWidget {
  final TextEditingController? controller;

  const _SearchBarField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Type a new booking',
        filled: false,
        border: InputBorder.none,
        icon: Padding(
          padding: EdgeInsetsDirectional.only(start: 12.0),
          child: Icon(Icons.search),
        ),
        contentPadding: EdgeInsetsDirectional.only(end: 16.0),
      ),
    );
  }
}

class _SearchBarItem extends StatelessWidget {
  final IconData? icon;
  final Widget? child;
  final bool enabled;

  const _SearchBarItem({
    super.key,
    this.icon,
    this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: child,
      selected: true,
      enabled: enabled,
      onTap: () {},
    );
  }
}

class _BookingSearchResult extends StatelessWidget {
  final Booking booking;

  const _BookingSearchResult({required this.booking, super.key});

  @override
  Widget build(BuildContext context) {
    final cabinManager = Provider.of<CabinManager>(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchResultLabel(
              label: booking.cabinId != null
                  ? '${appLocalizations.cabin} '
                      '${cabinManager.cabinFromId(booking.cabinId).number}'
                  : null,
            ),
            _SearchResultLabel(label: booking.description),
          ],
        ),
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchResultLabel<DateRange>(
              label: booking.date != null
                  ? DateRange(
                      startDate: booking.startDateTime,
                      endDate: booking.endDateTime,
                    )
                  : null,
              formatter: (dateRange) {
                final startDate =
                    dateRange.startDate?.formatRelative(appLocalizations);

                final endDate = dateRange.endDate != null
                    ? DateFormat.Hm().format(dateRange.endDate!)
                    : null;

                return [
                  startDate,
                  endDate,
                ].whereNotNull().join('–');
              },
            ),
            const _SearchResultLabel(label: 'Sense repetició'),
          ],
        ),
      ],
    );
  }
}

class _SearchResultLabel<T> extends StatelessWidget {
  final T? label;
  final String Function(T)? formatter;

  const _SearchResultLabel({super.key, this.label, this.formatter});

  @override
  Widget build(BuildContext context) {
    return Text(
      label != null ? '${formatter?.call(label as T) ?? label}' : '—',
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}
