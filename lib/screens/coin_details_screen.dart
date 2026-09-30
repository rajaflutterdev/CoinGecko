import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stu/bloc/coin/coin_events.dart';
import 'package:stu/core/constant/constants.dart';
import '../bloc/coin/coin_bloc.dart';
import '../bloc/coin/coin_states.dart';
import '../core/constant/string_varibles.dart';
import '../data/model/coin_model.dart';
import '../storage/local_storage.dart';
import '../widgets/market_chart.dart';

class CoinInfoView extends StatelessWidget {
  final CoinModel coin;

  const CoinInfoView({super.key, required this.coin});



  Widget _statTile(String title, String value, {bool showInfo = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            if (showInfo) ...[
              const SizedBox(width: 4),
              Tooltip(
                  message: "$title - $value",
                  child: const Icon(Icons.info_outline, color: Colors.grey, size: 13)),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _historicalTile({
    required String title,
    required String price,
    required double changePercentage,
    required String date,
  })
  {
    final isPositive = changePercentage >= 0;
    final color = isPositive
        ? const Color(0xFF26A69A)
        : const Color(0xFFEF5350);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: color,
              size: 16,
            ),
            Text(
              '${changePercentage.abs().toStringAsFixed(1)}%',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          AppConstants.formatDate(date),
          style: const TextStyle(color: Colors.grey, fontSize: 11),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141921),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E2633)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  statistics,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _statTile(
                            marketCap,
                            AppConstants.formatCurrency(coin.marketCap),
                            showInfo: true,
                          ),
                          const SizedBox(height: 16),
                          _statTile(
                            fullyDilutedValuation,
                            AppConstants.formatCurrency(coin.fullyDilutedValuation),
                            showInfo: true,
                          ),
                          const SizedBox(height: 16),
                          _statTile(
                            tradingVolume,
                            AppConstants.formatCurrency(coin.totalVolume),
                            showInfo: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _statTile(
                            circulatingSupply,
                            AppConstants.formatSupply(coin.circulatingSupply),
                            showInfo: true,
                          ),
                          const SizedBox(height: 16),
                          _statTile(
                            totalSupply,
                            AppConstants.formatSupply(coin.totalSupply),
                            showInfo: true,
                          ),
                          const SizedBox(height: 16),
                          _statTile(
                            maxSupply,
                            AppConstants.formatSupply(coin.maxSupply),
                            showInfo: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141921),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E2633)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  historicalData,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _statTile(
                        hour24High,
                        AppConstants.formatCurrency(coin.high24h),
                      ),
                    ),
                    Expanded(
                      child: _statTile(hour24Low, AppConstants.formatCurrency(coin.low24h)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _historicalTile(
                        title: allTimeHigh,
                        price: AppConstants.formatCurrency(coin.ath),
                        changePercentage: coin.athChangePercentage,
                        date: coin.athDate,
                      ),
                    ),
                    Expanded(
                      child: _historicalTile(
                        title: allTimeLow,
                        price: AppConstants.formatCurrency(coin.atl),
                        changePercentage: coin.atlChangePercentage,
                        date: coin.atlDate,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CoinDetailsScreen extends StatefulWidget {
  final CoinModel coin;

  const CoinDetailsScreen({super.key, required this.coin});

  @override
  State<CoinDetailsScreen> createState() => _CoinDetailsScreenState();
}

class _CoinDetailsScreenState extends State<CoinDetailsScreen> {
  String selectedTimeframe = '24H';
  bool isPriceSelected = true;
  bool isWatchlisted = false;
  final storage = LocalStorage();
  final List<String> timeframes = [
    '1H',
    '24H',
    '7D',
    '1M',
    '3M',
    'YTD',
    '1Y',
    'MAX',
  ];



  Future<void> loadWatchlist() async {
    final list = await storage.getWatchlist();

    if (!mounted) return;

    setState(() {
      isWatchlisted = list.contains(widget.coin.id);
    });
  }

  Future<void> toggleWatchlist() async {
    if (isWatchlisted) {
      await storage.removeWatchlist(widget.coin.id);
    } else {
      await storage.addWatchlist(widget.coin.id);
    }

    setState(() {
      isWatchlisted = !isWatchlisted;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.read<CoinBloc>().add(GetChartEvent(widget.coin.id));
      }
    });
    loadWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        context.read<CoinBloc>().add(GetCoinsEvent());
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F141A),
        body: SafeArea(
          child: BlocBuilder<CoinBloc, CoinState>(
            builder: (context, state) {
              CoinModel coin = widget.coin;

              if (state is CoinDetailsLoaded) {
                coin = state.coin;
              }

              final isPositive = coin.priceChangePercentage24h >= 0;
              final changeColor = isPositive
                  ? const Color(0xFF26A69A)
                  : const Color(0xFFEF5350);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            context.read<CoinBloc>().add(GetCoinsEvent());
                            Navigator.pop(context);
                          },
                        ),
                        Image.network(
                          coin.image,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.currency_bitcoin,
                            color: Colors.amber,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          coin.symbol.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E2633),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '#${coin.marketCapRank.toInt()}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const Spacer(),

                        IconButton(
                          icon: isWatchlisted
                              ? Icon(Icons.star, color: Colors.yellow, size: 20)
                              : Icon(
                                  Icons.star_border,
                                  color: Colors.white,
                                  size: 20,
                                ),
                          onPressed: () {
                            toggleWatchlist();
                          },
                        ),
                      ],
                    ),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        _buildTab(overview, isSelected: true),
                        _buildTab(info),
                        _buildTab(markets),
                        _buildTab(portfolio),
                        _buildTab(news),
                        _buildTab(guides),
                      ],
                    ),
                  ),

                  const Divider(color: Color(0xFF1E2633), height: 1),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Coin Name Title
                        Text(
                          coin.name,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Price & 24H Percentage Change Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              AppConstants.money(coin.currentPrice),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                Icon(
                                  isPositive
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: changeColor,
                                  size: 18,
                                ),
                                Text(
                                  '${coin.priceChangePercentage24h.abs().toStringAsFixed(1)}% (24H)',
                                  style: TextStyle(
                                    color: changeColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Chart Type Toggle Controls
                        Row(
                          children: [
                            _buildToggleButton(
                              price,
                              isSelected: isPriceSelected,
                              onTap: () {
                                setState(() => isPriceSelected = true);
                              },
                            ),
                            const SizedBox(width: 8),
                            _buildToggleButton(
                              marketCap,
                              isSelected: !isPriceSelected,
                              onTap: () {
                                setState(() => isPriceSelected = false);
                              },
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A202C),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.show_chart,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Icon(
                                    Icons.candlestick_chart,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          height: 240,
                          child: BlocBuilder<CoinBloc, CoinState>(
                            builder: (context, state) {
                              if (state is ChartLoaded) {
                                return MarketChart(prices: state.prices);
                              }

                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF26A69A),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF141921),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: timeframes.map((tf) {
                              final isSelected = selectedTimeframe == tf;
                              return GestureDetector(
                                onTap: () {
                                  setState(() => selectedTimeframe = tf);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF232B36)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    tf,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey,
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF141921),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF1E2633)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildPerformanceItem(
                                hour24,
                                coin.priceChangePercentage24h,
                              ),
                              _buildPerformanceItem('7D', -1.7),
                              _buildPerformanceItem('14D', 6.6),
                              _buildPerformanceItem('30D', 6.9),
                              _buildPerformanceItem('60D', 28.7),
                              _buildPerformanceItem('1Y', -24.1),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                         Text(
                          marketStatistics,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        CoinInfoView(coin: coin),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, bottom: 8.0, top: 4.0),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildToggleButton(
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF232B36) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceItem(String period, double percentage) {
    final isPos = percentage >= 0;
    final color = isPos ? const Color(0xFF26A69A) : const Color(0xFFEF5350);

    return Column(
      children: [
        Text(period, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPos ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: color,
              size: 14,
            ),
            Text(
              '${percentage.abs().toStringAsFixed(1)}%',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
