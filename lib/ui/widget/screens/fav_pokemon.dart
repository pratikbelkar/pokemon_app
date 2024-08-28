import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/data/models/pokemon.dart';
import 'package:pokemon_app/providers/theme_provider.dart';
import 'package:pokemon_app/repo/hive_repo.dart';
import 'package:pokemon_app/ui/widget/screens/pokemon_details_screen.dart';

class FavPokemon extends ConsumerStatefulWidget {
  const FavPokemon({super.key});

  @override
  ConsumerState<FavPokemon> createState() => _FavPokemonState();
}

class _FavPokemonState extends ConsumerState<FavPokemon> {
  final List<Pokemon> pokemonList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      await ref.read(hiveProvider).getFavPokemonList().then(
            (value) => setState(
              () {
                pokemonList.addAll(value);
              },
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('favourite Pokemon'),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         ref.read(themeProvider.notifier).toggleTheme();
          //       },
          //       icon: Icon(Icons.light_mode)),
          // ],
        ),
        body: pokemonList.isEmpty
            ? Center(child: Text('no fav pokemon'))
            : ListView.builder(
                itemCount: pokemonList.length,
                itemBuilder: (context, index) {
                  final Pokemon pokemon = pokemonList[index];
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              PokemonDetailsScreen(pokemon: pokemon),
                        ),
                      );
                    },
                    title: Text(pokemon.name!),
                    subtitle: Text(pokemon.typeofpokemon!.first),
                    leading: Image.network(pokemon.imageurl!),
                    trailing: IconButton(
                        onPressed: () async {
                          await ref
                              .read(hiveProvider)
                              .removePokemonFromList(pokemon.id!)
                              .then((value) {
                            setState(() {
                              pokemonList.remove(pokemon);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'pokemon removed from favourites')));
                          }).catchError((e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'failed to remove pokemon from favourites')));
                          });
                        },
                        icon: const Icon(Icons.delete)),
                  );
                }));
  }
}
