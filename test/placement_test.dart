import 'package:flutter_test/flutter_test.dart';
import 'package:yurt_stack/game/placement.dart';

void main() {
  group('placeBlock', () {
    test('perfect placement keeps the platform aligned', () {
      final result = placeBlock(previousLeft: 100, previousWidth: 150, currentLeft: 103, currentWidth: 150);
      expect(result.perfect, isTrue);
      expect(result.left, 100);
      expect(result.width, 150);
    });

    test('cuts the right overhang when block lands to the right', () {
      final result = placeBlock(previousLeft: 100, previousWidth: 150, currentLeft: 120, currentWidth: 150);
      expect(result.missed, isFalse);
      expect(result.perfect, isFalse);
      expect(result.left, 120);
      expect(result.width, 130);
      expect(result.cutWidth, 20);
    });

    test('cuts the left overhang when block lands to the left', () {
      final result = placeBlock(previousLeft: 100, previousWidth: 150, currentLeft: 80, currentWidth: 150);
      expect(result.left, 100);
      expect(result.width, 130);
      expect(result.cutLeft, 80);
      expect(result.cutWidth, 20);
    });

    test('a fully missed block ends the round', () {
      final result = placeBlock(previousLeft: 100, previousWidth: 100, currentLeft: 220, currentWidth: 90);
      expect(result.missed, isTrue);
    });

    test('speed increases and has a ceiling', () {
      expect(speedForFloor(100), greaterThan(speedForFloor(1)));
      expect(speedForFloor(100000), 450);
    });
  });
}
