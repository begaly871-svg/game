import 'dart:math' as math;

class PlacementResult {
  const PlacementResult({
    required this.left,
    required this.width,
    this.cutLeft,
    this.cutWidth,
    this.perfect = false,
    this.missed = false,
  });

  final double left;
  final double width;
  final double? cutLeft;
  final double? cutWidth;
  final bool perfect;
  final bool missed;
}

PlacementResult placeBlock({
  required double previousLeft,
  required double previousWidth,
  required double currentLeft,
  required double currentWidth,
  double perfectTolerance = 4,
}) {
  final difference = currentLeft - previousLeft;
  if (difference.abs() <= perfectTolerance) {
    return PlacementResult(
      left: previousLeft,
      width: math.min(currentWidth, previousWidth),
      perfect: true,
    );
  }

  final overlap = math.min(previousLeft + previousWidth, currentLeft + currentWidth) -
      math.max(previousLeft, currentLeft);
  if (overlap <= 0) {
    return PlacementResult(left: currentLeft, width: 0, missed: true);
  }

  final left = math.max(previousLeft, currentLeft);
  final double cutLeft;
  if (currentLeft < previousLeft) {
    cutLeft = currentLeft;
  } else {
    cutLeft = previousLeft + previousWidth;
  }
  return PlacementResult(
    left: left,
    width: overlap,
    cutLeft: cutLeft,
    cutWidth: currentWidth - overlap,
  );
}

double speedForFloor(int floor, {double base = 150}) =>
    math.min(base + 18 * math.sqrt(floor), base * 3);
