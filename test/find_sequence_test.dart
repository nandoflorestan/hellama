import 'package:hellama/stdin.dart' show findSequence;
import 'package:test/test.dart';

void main() {
  group('findSequence', () {
    test('should return -2 when sequence is empty', () {
      expect(findSequence([1, 2, 3], []), -2);
    });

    test('should return -1 when source is shorter than sequence', () {
      expect(findSequence([1, 2], [1, 2, 3]), -3);
    });

    test('should find sequence at the beginning', () {
      expect(findSequence([1, 2, 3, 4, 5], [1, 2]), 0);
    });

    test('should find sequence in the middle', () {
      expect(findSequence([1, 2, 3, 4, 5], [3, 4]), 2);
    });

    test('should find sequence at the end', () {
      expect(findSequence([1, 2, 3, 4, 5], [4, 5]), 3);
    });

    test('should return -1 when sequence is not found', () {
      expect(findSequence([1, 2, 3, 4, 5], [6, 7]), -1);
    });

    test('should return -1 for partial match at the end', () {
      expect(findSequence([1, 2, 3, 4, 5], [5, 6]), -1);
    });

    test('should handle single-element sequences', () {
      expect(findSequence([1, 2, 3], [2]), 1);
    });

    test('should handle empty source list when sequence is not empty', () {
      expect(findSequence([], [1]), -3);
    });

    test('should handle identical source and sequence', () {
      expect(findSequence([1, 2, 3], [1, 2, 3]), 0);
    });

    test('should find the first occurrence of a repeated sequence', () {
      expect(findSequence([1, 2, 1, 2, 3], [1, 2]), 0);
    });

    test('should handle large lists', () {
      final source = List<int>.generate(1000, (i) => i % 10);
      final sequence = [7, 8, 9];
      expect(findSequence(source, sequence), 7);
    });

    test('should handle a sequence that is not present in a large list', () {
      final source = List<int>.generate(1000, (i) => i % 10);
      final sequence = [10, 11]; // These values won't be in source
      expect(findSequence(source, sequence), -1);
    });

    test('should find sequence with duplicate values', () {
      expect(findSequence([1, 1, 2, 1, 1, 3], [1, 1]), 0);
    });

    test('should find sequence with duplicate values later in the list', () {
      expect(findSequence([1, 2, 1, 1, 3], [1, 1]), 2);
    });
  });
}
