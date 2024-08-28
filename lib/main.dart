import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pokemon_app/repo/hive_repo.dart';
import 'package:pokemon_app/theme/styles.dart';
import 'package:pokemon_app/ui/widget/all_pokemon_screen.dart';

import 'providers/theme_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  HiveRepo().registerHiveAdapter();
  runApp(const ProviderScope(child: Pokemonapp()));
}

class Pokemonapp extends StatelessWidget {
  const Pokemonapp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final themeNotifier = ref.watch(themeProvider);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(themeNotifier, context),
          home: AllPokemonScreen(),
        );
      },
    );
  }
}
