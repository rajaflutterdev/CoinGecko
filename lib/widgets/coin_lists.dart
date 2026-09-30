
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/coin/coin_bloc.dart';
import '../bloc/coin/coin_events.dart';
import '../bloc/coin/coin_states.dart';
import '../core/constant/string_varibles.dart';
import 'coin_tiles_widget.dart';

class CoinList extends StatefulWidget {
  const CoinList({super.key});

  @override
  State<CoinList> createState() => _CoinListState();
}

class _CoinListState extends State<CoinList> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  RefreshIndicator(
      onRefresh: () async {
        context.read<CoinBloc>().add(RefreshCoinsEvent());
      },

      child: BlocBuilder<CoinBloc, CoinState>(
        builder: (context, state) {
          if (state is CoinLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CoinError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 50),
                    const SizedBox(height: 15),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CoinBloc>().add(GetCoinsEvent());
                      },
                      child:  Text(retry),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is CoinLoaded) {
            return ListView(
              padding: const EdgeInsets.all(14),
              children: [

                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    context.read<CoinBloc>().add(SearchCoinsEvent(value));
                  },
                  decoration:  InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: searchCoins,
                    suffixIcon: IconButton(onPressed: (){
                      searchController.clear();
                      FocusScope.of(context).unfocus();
                      context.read<CoinBloc>().add(SearchCoinsEvent(""));

                    },
                        icon: searchController.text.isEmpty? const SizedBox()
                        :Icon(Icons.clear_sharp))
                  ),
                  
                ),

                const SizedBox(height: 12),
                CoinListScreen(initialCoins: state.coins),
                const SizedBox(height: 12),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}