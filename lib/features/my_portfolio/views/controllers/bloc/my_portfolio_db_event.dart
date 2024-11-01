part of 'my_portfolio_db_bloc.dart';

sealed class MyPortfolioDbEvent extends Equatable {
  const MyPortfolioDbEvent();

  @override
  List<Object> get props => [];
}

class InsertMyPortfolioDbEvent extends MyPortfolioDbEvent {
  const InsertMyPortfolioDbEvent(this.myPortfolio);

  final MyPortfolioModel myPortfolio;

  @override
  List<Object> get props => [myPortfolio];
}

class UpdateMyPortfolioDbEvent extends MyPortfolioDbEvent {
  const UpdateMyPortfolioDbEvent(this.myPortfolio);

  final MyPortfolioModel myPortfolio;

  @override
  List<Object> get props => [myPortfolio];
}

class DeleteMyPortfolioDbEvent extends MyPortfolioDbEvent {
  const DeleteMyPortfolioDbEvent(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

class GetMyPortfolioByIdDbEvent extends MyPortfolioDbEvent {
  const GetMyPortfolioByIdDbEvent(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

class GetMyPortfolioListDbEvent extends MyPortfolioDbEvent {
  const GetMyPortfolioListDbEvent();

  @override
  List<Object> get props => [];
}
