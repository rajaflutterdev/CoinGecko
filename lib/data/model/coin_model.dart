

class CoinModel {
  final String id;
  final String symbol;
  final String name;
  final String image;

  final double currentPrice;
  final double marketCap;
  final double marketCapRank;
  final double fullyDilutedValuation;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double totalVolume;

  final double circulatingSupply;
  final double totalSupply;
  final double maxSupply;

  final double high24h;
  final double low24h;

  final double ath;
  final double athChangePercentage;
  final String athDate;

  final double atl;
  final double atlChangePercentage;
  final String atlDate;

  CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.fullyDilutedValuation,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.totalVolume,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.high24h,
    required this.low24h,
    required this.ath,
    required this.athChangePercentage,
    required this.athDate,
    required this.atl,
    required this.atlChangePercentage,
    required this.atlDate,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',

      currentPrice:
      (json['current_price'] as num?)?.toDouble() ?? 0.0,

      marketCap:
      (json['market_cap'] as num?)?.toDouble() ?? 0.0,

      marketCapRank:
      (json['market_cap_rank'] as num?)?.toDouble() ?? 0.0,

      fullyDilutedValuation:
      (json['fully_diluted_valuation'] as num?)
          ?.toDouble() ??
          0.0,

      priceChange24h:
      (json['price_change_24h'] as num?)?.toDouble() ?? 0.0,

      priceChangePercentage24h:
      (json['price_change_percentage_24h'] as num?)
          ?.toDouble() ??
          0.0,

      totalVolume:
      (json['total_volume'] as num?)?.toDouble() ?? 0.0,

      circulatingSupply:
      (json['circulating_supply'] as num?)?.toDouble() ?? 0.0,

      totalSupply:
      (json['total_supply'] as num?)?.toDouble() ?? 0.0,

      maxSupply:
      (json['max_supply'] as num?)?.toDouble() ?? 0.0,

      high24h:
      (json['high_24h'] as num?)?.toDouble() ?? 0.0,

      low24h:
      (json['low_24h'] as num?)?.toDouble() ?? 0.0,

      ath:
      (json['ath'] as num?)?.toDouble() ?? 0.0,

      athChangePercentage:
      (json['ath_change_percentage'] as num?)
          ?.toDouble() ??
          0.0,

      athDate:
      json['ath_date']?.toString() ?? '',

      atl:
      (json['atl'] as num?)?.toDouble() ?? 0.0,

      atlChangePercentage:
      (json['atl_change_percentage'] as num?)
          ?.toDouble() ??
          0.0,

      atlDate:
      json['atl_date']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,

      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'fully_diluted_valuation': fullyDilutedValuation,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h':
      priceChangePercentage24h,
      'total_volume': totalVolume,

      'circulating_supply': circulatingSupply,
      'total_supply': totalSupply,
      'max_supply': maxSupply,

      'high_24h': high24h,
      'low_24h': low24h,

      'ath': ath,
      'ath_change_percentage': athChangePercentage,
      'ath_date': athDate,

      'atl': atl,
      'atl_change_percentage': atlChangePercentage,
      'atl_date': atlDate,
    };
  }

  factory CoinModel.fromFirestore(
      Map<String, dynamic> data,
      ) {
    return CoinModel.fromJson(data);
  }
}