import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/dialog.dart';
import 'package:cabin_booking/utils/string_extension.dart';
import 'package:cabin_booking/widgets/jump_bar/booking_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class JumpBar extends StatefulWidget {
  final int maxVisibleItems;

  const JumpBar({super.key, this.maxVisibleItems = 5});

  @override
  State<JumpBar> createState() => _JumpBarState();
}

class _JumpBarState extends State<JumpBar> {
  final TextEditingController _controller = TextEditingController();

  SingleBooking? _suggestedBooking;

  List<Booking> _searchedBookings = [];

  static const double _barHeight = 48;
  static const double _itemHeight = 52;
  static const double _suggestedBookingsCount = 1;

  double get _totalItems => _searchedBookings.length + _suggestedBookingsCount;

  double get _height =>
      (_totalItems * _itemHeight).clamp(_itemHeight, _maxHeight);

  double get _maxHeight => _itemHeight * widget.maxVisibleItems;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_handleInputChange);
  }

  void _handleInputChange() {
    final appLocalizations = AppLocalizations.of(context)!;

    // Cabin.
    final cabinTokens =
        _controller.text.tokenize(TokenizedCabin.expressions(appLocalizations));
    final cabin = Provider.of<CabinManager>(context, listen: false)
        .findCabinFromTokenized(TokenizedCabin.fromTokens(cabinTokens));

    // Booking.
    final bookingTokens = _controller.text
        .tokenize(TokenizedBooking.expressions(appLocalizations));
    final booking = TokenizedBooking.fromTokens(bookingTokens)
        .toSingleBooking(appLocalizations)
        .copyWith(cabinId: cabin?.id);

    final searchedBookings = Provider.of<CabinManager>(
      context,
      listen: false,
    ).searchBookings(_controller.text, perCabinLimit: 5);

    setState(() {
      _suggestedBooking = booking;
      _searchedBookings = searchedBookings.toList();
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
        height: _barHeight + _maxHeight,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _barHeight + _height,
              width: 360,
              child: Material(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                elevation: 12,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _JumpBarField(controller: _controller),
                    if (_searchedBookings.isNotEmpty) const Divider(height: 0),
                    SizedBox(
                      height: _height,
                      child: _JumpBarResults(
                        suggestedBooking: _suggestedBooking,
                        searchedBookings: _searchedBookings,
                        itemExtent: _itemHeight,
                      ),
                    ),
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

class _JumpBarResults extends StatelessWidget {
  final SingleBooking? suggestedBooking;
  final List<Booking>? searchedBookings;
  final double itemExtent;

  const _JumpBarResults({
    super.key,
    this.suggestedBooking,
    this.searchedBookings,
    required this.itemExtent,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      itemExtent: itemExtent,
      children: [
        if (suggestedBooking != null)
          _JumpBarItem(
            icon: Icons.auto_awesome,
            selected: true,
            child: BookingSearchResult(booking: suggestedBooking!),
            onTap: () async {
              final cabinManager =
                  Provider.of<CabinManager>(context, listen: false);

              Navigator.of(context).pop();

              return showNewBookingDialog(
                context: context,
                booking: suggestedBooking!.copyWith(
                  cabinId:
                      suggestedBooking!.cabinId ?? cabinManager.cabins.first.id,
                ),
                cabinManager: cabinManager,
              );
            },
          ),
        if (searchedBookings != null)
          for (final booking in searchedBookings!)
            _JumpBarItem(
              icon: Icons.event,
              child: BookingSearchResult(booking: booking),
              onTap: () {},
            ),
      ],
    );
  }
}

class _JumpBarField extends StatelessWidget {
  final TextEditingController? controller;

  const _JumpBarField({super.key, this.controller});

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
          padding: EdgeInsetsDirectional.only(start: 12),
          child: Icon(Icons.search),
        ),
        contentPadding: EdgeInsetsDirectional.only(end: 16),
      ),
    );
  }
}

class _JumpBarItem extends StatelessWidget {
  final IconData? icon;
  final Widget? child;
  final bool selected;
  final VoidCallback? onTap;

  const _JumpBarItem({
    super.key,
    this.icon,
    this.child,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: child,
      selected: selected,
      onTap: onTap,
    );
  }
}
