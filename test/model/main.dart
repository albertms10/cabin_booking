import 'booking/recurring_booking_test.dart' as recurring_booking_test;
import 'booking/single_booking_test.dart' as single_booking_test;
import 'cabin/cabin_elements_test.dart' as cabin_elements_test;
import 'cabin/cabin_test.dart' as cabin_test;
import 'cabin/piano_test.dart' as piano_test;
import 'cabin/tokenized_cabin_test.dart' as tokenized_cabin_test;
import 'date/date_range_test.dart' as date_range_test;
import 'date/date_ranger_test.dart' as date_ranger_test;
import 'date/holiday_test.dart' as holiday_test;
import 'school_year/school_year_test.dart' as school_year_test;

void main() {
  recurring_booking_test.main();
  single_booking_test.main();
  cabin_elements_test.main();
  cabin_test.main();
  piano_test.main();
  tokenized_cabin_test.main();
  date_range_test.main();
  date_ranger_test.main();
  holiday_test.main();
  school_year_test.main();
}
