part of 'my_portfolio_db_bloc.dart';

final class MyPortfolioDbState extends Equatable {
  const MyPortfolioDbState({
    this.insertMyPortfolioSuccess = false,
    this.updateMyPortfolioSuccess = false,
    this.deleteMyPortfolioSuccess = false,
    this.errorMessage,
    this.myPortfolio,
    this.myPortfolios = const [],
  });

  final bool insertMyPortfolioSuccess;
  final bool updateMyPortfolioSuccess;
  final bool deleteMyPortfolioSuccess;
  final String? errorMessage;
  final MyPortfolioModel? myPortfolio;
  final List<MyPortfolioModel> myPortfolios;

  MyPortfolioDbState copyWith({
    bool? insertMyPortfolioSuccess,
    bool? updateMyPortfolioSuccess,
    bool? deleteMyPortfolioSuccess,
    String? errorMessage,
    MyPortfolioModel? myPortfolio,
    List<MyPortfolioModel>? myPortfolios,
  }) {
    return MyPortfolioDbState(
      insertMyPortfolioSuccess:
          insertMyPortfolioSuccess ?? this.insertMyPortfolioSuccess,
      updateMyPortfolioSuccess:
          updateMyPortfolioSuccess ?? this.updateMyPortfolioSuccess,
      deleteMyPortfolioSuccess:
          deleteMyPortfolioSuccess ?? this.deleteMyPortfolioSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      myPortfolio: myPortfolio ?? this.myPortfolio,
      myPortfolios: myPortfolios ?? this.myPortfolios,
    );
  }

  @override
  List<Object?> get props => [
        insertMyPortfolioSuccess,
        updateMyPortfolioSuccess,
        deleteMyPortfolioSuccess,
        errorMessage,
        myPortfolio,
        myPortfolios,
      ];
}
