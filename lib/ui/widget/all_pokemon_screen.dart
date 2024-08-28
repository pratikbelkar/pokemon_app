import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/data/models/pokemon.dart';
import 'package:pokemon_app/providers/pokemon_providers.dart';
import 'package:pokemon_app/providers/theme_provider.dart';
import 'package:pokemon_app/ui/widget/screens/fav_pokemon.dart';
import 'package:pokemon_app/ui/widget/screens/pokemon_details_screen.dart';
import 'package:pokemon_app/utils/helpers.dart';

class AllPokemonScreen extends ConsumerWidget {
  const AllPokemonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Pokemon>> allpokemon = ref.watch(pokemonFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Pokemons',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FavPokemon()));
              }),
          IconButton(
            icon: const Icon(Icons.lightbulb),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          )
        ],
      ),
      body: allpokemon.when(
          data: (data) {
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  final pokemon = data[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              PokemonDetailsScreen(pokemon: pokemon)));
                    },
                    child: Card(
                      color: Helpers.getPokemonCardColour(
                          pokemonType: pokemon.typeofpokemon!.first),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            left: 10,
                            child: Text(
                              pokemon.name!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                          Positioned(
                            top: 50,
                            left: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5.0, right: 5.0, top: 2, bottom: 2),
                                  child: Text(
                                    pokemon.typeofpokemon!.first,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              right: -10,
                              bottom: -10,
                              child: Image.asset(
                                'images/pokeball.png',
                                height: 110,
                                width: 110,
                              )),
                          Positioned(
                            bottom: 0,
                            right: -10,
                            child: Hero(
                              tag: pokemon.id!,
                              child: CachedNetworkImage(
                                height: 120,
                                width: 120,
                                imageUrl: pokemon.imageurl!,
                                placeholder: (context, url) => const SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          error: (error, skt) {
            Text(error.toString());
            return null;
          },
          loading: () => const Center(
                child: CircularProgressIndicator(),
              )),
    );
  }
}
