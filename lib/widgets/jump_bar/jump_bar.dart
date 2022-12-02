import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/string_extension.dart';
import 'package:cabin_booking/widgets/jump_bar/booking_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class JumpBar extends StatefulWidget {
  const JumpBar({super.key});

  @override
  State<JumpBar> createState() => _JumpBarState();
}

class _JumpBarState extends State<JumpBar> {
  final TextEditingController _controller = TextEditingController();

  Booking? _suggestedBooking;

  List<int> get _items => const [1];

  static const double _searchBarHeight = 48;
  static const double _itemHeight = 64;

  double get _height =>
      _searchBarHeight + _itemHeight + (_items.length * _itemHeight);

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

    setState(() {
      _suggestedBooking = booking;
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
        height: 200,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _height,
              width: 360,
              child: Material(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                elevation: 12,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SearchBarField(controller: _controller),
                    if (_items.isNotEmpty) const Divider(height: 0),
                    if (_suggestedBooking != null)
                      _SearchBarItem(
                        icon: Icons.auto_awesome,
                        child: BookingSearchResult(booking: _suggestedBooking!),
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
          padding: EdgeInsetsDirectional.only(start: 12),
          child: Icon(Icons.search),
        ),
        contentPadding: EdgeInsetsDirectional.only(end: 16),
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
