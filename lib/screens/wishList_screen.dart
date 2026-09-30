import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/coin/coin_bloc.dart';
import '../bloc/coin/coin_states.dart';
import '../core/constant/string_varibles.dart';
import '../data/model/coin_model.dart';
import '../storage/local_storage.dart';
import '../widgets/coin_tile.dart';
import 'coin_details_screen.dart';


class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final LocalStorage storage = LocalStorage();

  List<String> localdata = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWatchlist();
  }

  Future<void> loadWatchlist() async {
    final data = await storage.getWatchlist();

    if (!mounted) return;

    setState(() {
      localdata = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocBuilder<CoinBloc, CoinState>(
      builder: (context, state) {
        if (state is! CoinLoaded) {
          return  Center(child: Text(loadMarket));
        }

        final List<CoinModel> coins = state.coins
            .where((coin) => localdata.contains(coin.id))
            .toList();

        if (coins.isEmpty) {
          return  Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_border, size: 60),
                SizedBox(height: 15),
                Text(noCoins),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                   SizedBox(
                    width: 38,
                    child: Center(
                      child: Text(
                        symbol,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ),

                   Expanded(
                    flex: 6,
                    child: Text(
                      coin,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),

                   Expanded(
                    flex: 3,
                    child: Text(
                      price,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),

                   Expanded(
                    flex: 3,
                    child: Text(
                      hour24,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),

                   Expanded(
                    flex: 3,
                    child: Text(
                      marketCap,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: coins.length,
                itemBuilder: (context, index) {
                  final CoinModel coin = coins[index];

                  return CoinTile(
                    coin: coin,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CoinDetailsScreen(coin: coin),
                        ),
                      );

                      loadWatchlist();
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
