import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stu/screens/wishList_screen.dart';
import '../bloc/coin/coin_bloc.dart';
import '../bloc/coin/coin_events.dart';
import '../core/constant/string_varibles.dart';
import '../data/model/coin_model.dart';
import '../data/model/coinfilter_model.dart';
import '../widgets/coin_filters.dart';
import '../widgets/coin_lists.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int selectedIndex = 0;
  CoinFilterModel activeFilter = CoinFilterModel();
  List<CoinModel> allCoins = [];
  List<CoinModel> displayedCoins = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      context.read<CoinBloc>().add(GetCoinsEvent());
    }
  }


  List<CoinModel> filterCoins(List<CoinModel> coins, CoinFilterModel filter) {
    return coins.where((coin) {

      switch (filter.marketCap) {
        case 'Large: >\$1B':
          if (coin.marketCap <= 1000000000) return false;
          break;
        case 'Mid: \$100M to \$1B':
          if (coin.marketCap < 100000000 || coin.marketCap > 1000000000) {
            return false;
          }
          break;
        case 'Small: \$10M to \$100M':
          if (coin.marketCap < 10000000 || coin.marketCap >= 100000000) {
            return false;
          }
          break;
        case 'Micro: <\$10M':
          if (coin.marketCap >= 10000000) return false;
          break;
      }

      switch (filter.volume24h) {
        case '>\$100K':
          if (coin.totalVolume <= 100000) return false;
          break;
        case '>\$1M':
          if (coin.totalVolume <= 1000000) return false;
          break;
        case '>\$10M':
          if (coin.totalVolume <= 10000000) return false;
          break;
        case '>\$50M':
          if (coin.totalVolume <= 50000000) return false;
          break;
        case '>\$100M':
          if (coin.totalVolume <= 100000000) return false;
          break;
      }

      switch (filter.priceChange24h) {
        case '>10%':
          if (coin.priceChangePercentage24h <= 10) return false;
          break;
        case '>20%':
          if (coin.priceChangePercentage24h <= 20) return false;
          break;
        case '>50%':
          if (coin.priceChangePercentage24h <= 50) return false;
          break;
        case '<-10%':
          if (coin.priceChangePercentage24h >= -10) return false;
          break;
        case '<-20%':
          if (coin.priceChangePercentage24h >= -20) return false;
          break;
        case '<-50%':
          if (coin.priceChangePercentage24h >= -50) return false;
          break;
      }

      final fdv = coin.fullyDilutedValuation;

      switch (filter.fdv) {
        case '>\$10M':
          if (fdv <= 10000000) return false;
          break;
        case '>\$100M':
          if (fdv <= 100000000) return false;
          break;
        case '>\$1B':
          if (fdv <= 1000000000) return false;
          break;
      }

      return true;
    }).toList();
  }

  void showCoinFilterBottomSheet({
    required BuildContext context,
    required CoinFilterModel currentFilter,
    required Function(CoinFilterModel) onApply,
  })
  {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141A22),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FilterBottomSheet(
          currentFilter: currentFilter,
          onApply: onApply,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedIndex == 0 ? coinGecko : wishlist,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onPressed: () {
              showCoinFilterBottomSheet(
                context: context,
                currentFilter: activeFilter,
                onApply: (updatedFilter) {
                  setState(() {
                    activeFilter = updatedFilter;
                    displayedCoins = filterCoins(allCoins, activeFilter);
                  });

                  context.read<CoinBloc>().add(
                    FilterCoins(filterData: displayedCoins),
                  );
                },
              );
            },
          ),
        ],
      ),

      body: selectedIndex == 0 ? CoinList() : WishlistScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations:  [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: market,
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border),
            selectedIcon: Icon(Icons.star),
            label: wishlist,
          ),
        ],
      ),
    );
  }
}
