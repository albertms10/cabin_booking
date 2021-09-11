extension IntExtension on int {
  int mod(int mod, [int shift = 0]) => (this + shift) % mod;

  int weekDayMod([int shift = 0]) => mod(DateTime.daysPerWeek, shift);
}
