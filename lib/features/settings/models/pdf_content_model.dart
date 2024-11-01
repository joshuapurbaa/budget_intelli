class PdfContentModel {
  PdfContentModel({
    required this.type,
    required this.categoryName,
    required this.plannedAmount,
    required this.actualAmount,
  });

  final String type;
  final String categoryName;
  final String plannedAmount;
  final String actualAmount;
}
