import 'package:dio/dio.dart';
import '../../core/constant/api_constant.dart';
import '../model/coin_model.dart';
import 'firebase_service.dart';

class ApiService {
  late final Dio dio;

  final FirebaseService firebaseService=FirebaseService();

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          //'x-cg-demo-api-key': 'YOUR_FREE_API_KEY',
        },
      ),
    );
  }




  Future<List<CoinModel>> getMarkets() async {
    try {
      final response = await dio.get(
        ApiConstants.markets,
        queryParameters: {
          'vs_currency': 'usd',
          'order': 'market_cap_desc',
          'per_page': 50,
          'page': 1,
          'sparkline': false,
          'price_change_percentage': '24h',
        },
      );
      final List data = response.data;

      final resultData = data.map((json) => CoinModel.fromJson(json)).toList();
      return resultData;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error'] ?? e.message ?? 'Something went wrong',
      );
    }
  }

  Future<CoinModel> getCoin(String id) async {
    try {
      final response = await dio.get(
        '${ApiConstants.coins}/$id',
        queryParameters: {
          'localization': false,
          'tickers': false,
          'market_data': true,
          'community_data': false,
          'developer_data': false,
        },
      );

      final data = response.data;
      return CoinModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error'] ?? e.message ?? 'Unable to load coin',
      );
    }
  }

  Future<List<double>> getChart(String id) async {
    try {
      final response = await dio.get(
        '${ApiConstants.coins}/$id${ApiConstants.marketChart}',
        queryParameters: {'vs_currency': 'usd', 'days': 7},
      );

      final prices = response.data['prices'] as List;

      return prices.map<double>((item) {
        return (item[1] as num).toDouble();
      }).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['error'] ?? e.message ?? 'Unable to load chart',
      );
    }
  }
}
