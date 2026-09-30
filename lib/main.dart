import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'bloc/coin/coin_bloc.dart';
import 'core/theme/app_theme.dart';
import 'data/repository/coin_repository.dart';
import 'data/service/api_service.dart';
import 'firebase_options.dart';
import 'screens/market_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final apiService = ApiService();
  final repository = CoinRepository(apiService: apiService);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatefulWidget {
  final CoinRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CoinRepository>.value(
      value: widget.repository,

      child: BlocProvider(
        create: (_) => CoinBloc(repository: widget.repository),

        child: MaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'CryptoTracker',

          theme: AppTheme.darkTheme,

          home: const MarketScreen(),
        ),
      ),
    );
  }
}
