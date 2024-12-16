import 'dart:math';

class BillNumberGenerator {
  static String generate() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString();
    final random = Random().nextInt(1000).toString().padLeft(3, '0');
    return 'BILL-${now.year}${now.month.toString().padLeft(2, '0')}$random';
  }
}
