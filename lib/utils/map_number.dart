// Gist: https://gist.github.com/marcschneider/6991761

/// Re-maps a number from one range to another (default from 0 to 1).
double mapNumber(
  double value, {
  double inMin = 0.0,
  double inMax = 1.0,
  double outMin = 0.0,
  double outMax = 1.0,
}) =>
    ((value - inMin) * (outMax - outMin)) / (inMax - inMin) + outMin;
