class MyPortfolioModel {
  MyPortfolioModel({
    required this.id,
    required this.stockSymbol,
    required this.companyName,
    required this.buyPrice,
    required this.closePrice,
    required this.lot,
    required this.stopLoss,
    required this.buyDate,
    required this.createdAt,
    required this.updatedAt,
    required this.buyReason,
    this.takeProfit,
  });

  factory MyPortfolioModel.fromMap(Map<String, dynamic> map) {
    return MyPortfolioModel(
      id: map['id'] as String,
      stockSymbol: map['stock_symbol'] as String,
      companyName: map['company_name'] as String,
      buyPrice: map['buy_price'] as double,
      closePrice: map['close_price'] as double,
      lot: map['lot'] as int,
      stopLoss: map['stop_loss'] as double,
      takeProfit: map['take_profit'] as double?,
      buyDate: map['buy_date'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      buyReason: map['buy_reason'] as String,
    );
  }

  final String id;
  final String stockSymbol;
  final String companyName;
  final double buyPrice;
  final double closePrice;
  final int lot;
  final double stopLoss;
  final double? takeProfit;
  final String buyDate;
  final String createdAt;
  final String updatedAt;
  final String buyReason;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stock_symbol': stockSymbol,
      'company_name': companyName,
      'buy_price': buyPrice,
      'close_price': closePrice,
      'lot': lot,
      'stop_loss': stopLoss,
      'take_profit': takeProfit,
      'buy_date': buyDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'buy_reason': buyReason,
    };
  }

  MyPortfolioModel copyWith({
    String? id,
    String? stockSymbol,
    String? companyName,
    double? buyPrice,
    double? closePrice,
    int? lot,
    double? stopLoss,
    double? takeProfit,
    String? buyDate,
    String? createdAt,
    String? updatedAt,
    String? buyReason,
  }) {
    return MyPortfolioModel(
      id: id ?? this.id,
      stockSymbol: stockSymbol ?? this.stockSymbol,
      companyName: companyName ?? this.companyName,
      buyPrice: buyPrice ?? this.buyPrice,
      closePrice: closePrice ?? this.closePrice,
      lot: lot ?? this.lot,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit: takeProfit ?? this.takeProfit,
      buyDate: buyDate ?? this.buyDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      buyReason: buyReason ?? this.buyReason,
    );
  }
}
