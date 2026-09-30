import 'package:equatable/equatable.dart';

import '../../data/model/coin_model.dart';

abstract class CoinEvent extends Equatable {
  const CoinEvent();

  @override
  List<Object?> get props => [];
}

class GetCoinsEvent extends CoinEvent {}

class SearchCoinsEvent extends CoinEvent {
  final String search;

  const SearchCoinsEvent(this.search);

  @override
  List<Object?> get props => [search];
}

class RefreshCoinsEvent extends CoinEvent {}

class GetCoinDetailsEvent extends CoinEvent {
  final String id;

  const GetCoinDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class GetChartEvent extends CoinEvent {
  final String id;

  const GetChartEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterCoins extends CoinEvent {
  final List<CoinModel> filterData;

  const FilterCoins({required this.filterData});

  @override
  List<Object?> get props => [filterData];
}