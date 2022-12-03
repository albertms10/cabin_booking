import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/string_extension.dart';
import 'package:cabin_booking/widgets/jump_bar/jump_bar_field.dart';
import 'package:cabin_booking/widgets/jump_bar/jump_bar_results.dart';
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

  double get _maxHeight => _itemHeight * widget.maxVisibleItems;

  double get _height =>
      (_totalItems * _itemHeight).clamp(_itemHeight, _maxHeight);

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
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: _height, end: _height),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              builder: (context, height, child) {
                return SizedBox(
                  width: 360,
                  height: _barHeight + height,
                  child: Material(
                    elevation: 12,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        JumpBarField(controller: _controller),
                        const Divider(height: 0),
                        SizedBox(
                          height: height,
                          child: JumpBarResults(
                            suggestedBooking: _suggestedBooking,
                            searchedBookings: _searchedBookings,
                            itemExtent: _itemHeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
