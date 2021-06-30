class Measure {
  final String id;
  final String childId;
  final String measureDate;
  final String measureHeight;
  final String measureWeight;
  final String measurePerimeter;
  final double measureIMC;
  final int measureWeekDiff;
  final int measureMonthDiff;

  Measure(
      {this.id,
      this.childId,
      this.measureDate,
      this.measureHeight,
      this.measureWeight,
      this.measurePerimeter,
      this.measureIMC,
      this.measureWeekDiff,
      this.measureMonthDiff});
}
