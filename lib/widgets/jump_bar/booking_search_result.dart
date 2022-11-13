import 'package:cabin_booking/model.dart';
import 'package:cabin_booking/utils/date_time_extension.dart';
import 'package:cabin_booking/widgets/jump_bar/search_result_label.dart';
import 'package:collection/collection.dart' show IterableNullableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingSearchResult extends StatelessWidget {
  final Booking booking;

  const BookingSearchResult({required this.booking, super.key});

  @override
  Widget build(BuildContext context) {
    final cabinManager = Provider.of<CabinManager>(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchResultLabel(
          label: booking.description,
          placeholder: appLocalizations.description,
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchResultLabel(
              label: booking.cabinId != null
                  ? '${appLocalizations.cabin} '
                      '${cabinManager.cabinFromId(booking.cabinId).number}'
                  : null,
              placeholder: appLocalizations.cabin,
            ),
            const SizedBox(width: 12),
            SearchResultLabel<DateRange>(
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
          ],
        ),
      ],
    );
  }
}
