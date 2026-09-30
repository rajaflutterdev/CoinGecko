class CoinFilterModel {
  String marketCap;
  String volume24h;
  String priceChange24h;
  String fdv;

  CoinFilterModel({
    this.marketCap = 'All',
    this.volume24h = 'All',
    this.priceChange24h = 'All',
    this.fdv = 'All',
  });

  CoinFilterModel copyWith({
    String? marketCap,
    String? volume24h,
    String? priceChange24h,
    String? fdv,
  }) {
    return CoinFilterModel(
      marketCap: marketCap ?? this.marketCap,
      volume24h: volume24h ?? this.volume24h,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      fdv: fdv ?? this.fdv,
    );
  }

  void reset() {
    marketCap = 'All';
    volume24h = 'All';
    priceChange24h = 'All';
    fdv = 'All';
  }
}