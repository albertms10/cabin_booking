// Gist: https://gist.github.com/marcschneider/6991761

/// Re-maps a number from one range to another (default from 0 to 1).
double mapNumber(
  num value, {
  num inMin = 0.0,
  num inMax = 1.0,
  num outMin = 0.0,
  num outMax = 1.0,
}) =>
    ((value - inMin) * (outMax - outMin)) / (inMax - inMin) + outMin;
