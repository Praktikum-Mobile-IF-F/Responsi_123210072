import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:responsi072/constant/colors.dart';
import 'package:responsi072/models/boxes.dart';
import 'package:responsi072/models/favorite.dart';
import 'package:responsi072/navigation/app_navigation.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteAdapter());
  Hive.registerAdapter(KopiAdapter());
  await Hive.openBox<Favorite>(HiveBoxes.favorite);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Responsi Prak TPM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigation.router,
    );
  }
}
