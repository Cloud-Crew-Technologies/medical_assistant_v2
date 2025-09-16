class MedicalCondition {
  final String name;
  final int color;
  final bool isLarge;

  const MedicalCondition({
    required this.name,
    required this.color,
    this.isLarge = false,
  });
}