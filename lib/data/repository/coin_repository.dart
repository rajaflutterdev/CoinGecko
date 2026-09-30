

import '../model/coin_model.dart';
import '../service/api_service.dart';

class CoinRepository {
  final ApiService apiService;

  CoinRepository({
    required this.apiService,
  });

  Future<List<CoinModel>> getMarkets() {
    return apiService.getMarkets();
  }

  Future<CoinModel> getCoin(String id) {
    return apiService.getCoin(id);
  }

  Future<List<double>> getChart(String id) {
    return apiService.getChart(id);
  }
}