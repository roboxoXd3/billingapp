import 'package:equatable/equatable.dart';

class EyePrescription extends Equatable {
  final double sphericalRight;
  final double sphericalLeft;
  final double cylindricalRight;
  final double cylindricalLeft;
  final int axisRight;
  final int axisLeft;
  final double addRight;
  final double addLeft;
  final String visualAcuityRight;
  final String visualAcuityLeft;
  final Map<String, bool> medicalHistory;

  const EyePrescription({
    this.sphericalRight = 0.0,
    this.sphericalLeft = 0.0,
    this.cylindricalRight = 0.0,
    this.cylindricalLeft = 0.0,
    this.axisRight = 0,
    this.axisLeft = 0,
    this.addRight = 0.0,
    this.addLeft = 0.0,
    this.visualAcuityRight = '',
    this.visualAcuityLeft = '',
    this.medicalHistory = const {
      'diabetic': false,
      'hypertensive': false,
      'cardiac': false,
      'asthmatic': false,
      'allergicToDrug': false,
    },
  });

  @override
  List<Object?> get props => [
        sphericalRight,
        sphericalLeft,
        cylindricalRight,
        cylindricalLeft,
        axisRight,
        axisLeft,
        addRight,
        addLeft,
        visualAcuityRight,
        visualAcuityLeft,
        medicalHistory,
      ];

  EyePrescription copyWith({
    double? sphericalRight,
    double? sphericalLeft,
    double? cylindricalRight,
    double? cylindricalLeft,
    int? axisRight,
    int? axisLeft,
    double? addRight,
    double? addLeft,
    String? visualAcuityRight,
    String? visualAcuityLeft,
    Map<String, bool>? medicalHistory,
  }) {
    return EyePrescription(
      sphericalRight: sphericalRight ?? this.sphericalRight,
      sphericalLeft: sphericalLeft ?? this.sphericalLeft,
      cylindricalRight: cylindricalRight ?? this.cylindricalRight,
      cylindricalLeft: cylindricalLeft ?? this.cylindricalLeft,
      axisRight: axisRight ?? this.axisRight,
      axisLeft: axisLeft ?? this.axisLeft,
      addRight: addRight ?? this.addRight,
      addLeft: addLeft ?? this.addLeft,
      visualAcuityRight: visualAcuityRight ?? this.visualAcuityRight,
      visualAcuityLeft: visualAcuityLeft ?? this.visualAcuityLeft,
      medicalHistory: medicalHistory ?? this.medicalHistory,
    );
  }

  // Helper method to format prescription for display
  Map<String, String> getFormattedPrescription() {
    return {
      'rightEye':
          '${_formatNumber(sphericalRight)} ${_formatNumber(cylindricalRight)} × $axisRight',
      'leftEye':
          '${_formatNumber(sphericalLeft)} ${_formatNumber(cylindricalLeft)} × $axisLeft',
      'addRight': _formatNumber(addRight),
      'addLeft': _formatNumber(addLeft),
    };
  }

  String _formatNumber(double number) {
    if (number == 0) return '0.00';
    String prefix = number > 0 ? '+' : '';
    return '$prefix${number.toStringAsFixed(2)}';
  }
}
