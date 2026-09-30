import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stu/core/constant/api_constant.dart';
import 'package:stu/data/model/coin_model.dart';
import '../../data/repository/coin_repository.dart';
import '../../data/service/firebase_service.dart';
import 'coin_events.dart';
import 'coin_states.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final CoinRepository repository;
  final FirebaseService firebaseService = FirebaseService();

  List allCoins = [];
  CoinBloc({required this.repository}) : super(CoinInitial()) {
    on<GetCoinsEvent>(_getCoins);
    on<SearchCoinsEvent>(_searchCoins);
    on<RefreshCoinsEvent>(_refreshCoins);
    on<GetCoinDetailsEvent>(_getCoinDetails);
    on<GetChartEvent>(_getChart);
    on<FilterCoins>(filteredCoin);
  }

  Future<void> _getCoins(GetCoinsEvent event, Emitter<CoinState> emit) async {
    emit(CoinLoading());

    try {
      final firebaseData = await checkTheFireBaseCollection();
      if (firebaseData.isEmpty) {
        final coins = await repository.getMarkets();
        allCoins = coins;
        emit(CoinLoaded(coins));
        await firebaseService.setData(
          collection: ApiConstants.collection,
          documentId: ApiConstants.documentName,
          data: {"coins": coins.map((coin) => coin.toJson()).toList()},
        );
      } else {
        allCoins = firebaseData;
        emit(CoinLoaded(firebaseData));
      }
    } catch (e) {
      emit(CoinError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void _searchCoins(SearchCoinsEvent event, Emitter<CoinState> emit) {
    final search = event.search.toLowerCase().trim();

    if (search.isEmpty) {

      emit(CoinLoaded(List.from(allCoins)));
      return;
    }

    final filtered = allCoins.where((coin) {
      return coin.name.toLowerCase().contains(search) ||
          coin.symbol.toLowerCase().contains(search);
    }).toList();
    emit(CoinLoaded(List.from(filtered)));
  }

  Future<void> _refreshCoins(
    RefreshCoinsEvent event,
    Emitter<CoinState> emit,
  ) async {
    try {
      final firebaseData = await checkTheFireBaseCollection();
      if (firebaseData.isEmpty) {
        final coins = await repository.getMarkets();
        allCoins = coins;
        emit(CoinLoaded(coins));
        await firebaseService.setData(
          collection: ApiConstants.collection,
          documentId: ApiConstants.documentName,
          data: {"coins": coins.map((coin) => coin.toJson()).toList()},
        );
      } else {
        allCoins = firebaseData;
        emit(CoinLoaded(firebaseData));
      }
    } catch (e) {
      emit(CoinError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _getCoinDetails(
    GetCoinDetailsEvent event,
    Emitter<CoinState> emit,
  ) async {
    emit(CoinLoading());

    try {
      final coin = await repository.getCoin(event.id);

      emit(CoinDetailsLoaded(coin));
    } catch (e) {
      emit(CoinError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _getChart(GetChartEvent event, Emitter<CoinState> emit) async {
    try {
      final prices = await repository.getChart(event.id);

      emit(ChartLoaded(prices));
    } catch (e) {
      emit(CoinError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
  Future<void> filteredCoin(FilterCoins event, Emitter<CoinState> emit) async {
    try {
      emit(CoinLoaded(event.filterData));
    } catch (e) {
      emit(CoinError(event.filterData.isEmpty?"No Coins":""));
    }
  }


  Future<List<CoinModel>> checkTheFireBaseCollection() async {
    final documentCollectionData = await firebaseService.getAllData(
      collection: ApiConstants.collection,
      docName: ApiConstants.documentName,
    );
    return documentCollectionData;
  }
}
