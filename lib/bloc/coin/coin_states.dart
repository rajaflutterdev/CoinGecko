import 'package:equatable/equatable.dart';

import '../../data/model/coin_model.dart';


abstract class CoinState extends Equatable {
  const CoinState();

  @override
  List<Object?> get props => [];
}

class CoinInitial extends CoinState {}

class CoinLoading extends CoinState {}

class CoinLoaded extends CoinState {
  final List<CoinModel> coins;

  const CoinLoaded(this.coins);

  @override
  List<Object?> get props => [coins];
}

class CoinDetailsLoaded extends CoinState {
  final CoinModel coin;

  const CoinDetailsLoaded(this.coin);

  @override
  List<Object?> get props => [coin];
}

class ChartLoaded extends CoinState {
  final List<double> prices;

  const ChartLoaded(this.prices);

  @override
  List<Object?> get props => [prices];
}

class CoinError extends CoinState {
  final String message;

  const CoinError(this.message);

  @override
  List<Object?> get props => [message];
}