import 'package:flutter_test/flutter_test.dart';
import 'package:input_screen/main.dart';

void main() {
  group('BloodSugarController', () {
    late BloodSugarController controller;

    setUp(() {
      controller = BloodSugarController();
    });

    test('validateData returns true for valid data', () {
      controller.beforeMealController.text = '100';
      controller.afterMealController.text = '150';
      expect(controller.validateData(), true);
    });

    test('validateData returns false for invalid data', () {
      controller.beforeMealController.text = '0';
      controller.afterMealController.text = '150';
      expect(controller.validateData(), false);
    });

    test('validateData returns false for invalid data (negative value)', () {
      controller.beforeMealController.text = '-100';
      controller.afterMealController.text = '150';
      expect(controller.validateData(), false);
});

    
  });
}
