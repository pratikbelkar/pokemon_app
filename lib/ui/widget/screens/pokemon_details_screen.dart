import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/data/models/pokemon.dart';
import 'package:pokemon_app/providers/theme_provider.dart';

import 'package:pokemon_app/repo/hive_repo.dart';
import 'package:pokemon_app/ui/widget/pokemon_details_row.dart';
import 'package:pokemon_app/utils/helpers.dart';

class PokemonDetailsScreen extends ConsumerStatefulWidget {
  const PokemonDetailsScreen({super.key, required this.pokemon});
  final Pokemon pokemon;

  @override
  ConsumerState<PokemonDetailsScreen> createState() =>
      _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends ConsumerState<PokemonDetailsScreen> {
  @override
  Widget build(
    BuildContext context,
  ) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Helpers.getPokemonCardColour(
          pokemonType: widget.pokemon.typeofpokemon!.first),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Helpers.getPokemonCardColour(
            pokemonType: widget.pokemon.typeofpokemon!.first),
        actions: [
          IconButton(
              onPressed: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
              icon: Icon(Icons.light_mode_outlined)),
          Consumer(builder: (context, ref, child) {
            return IconButton(
              onPressed: () async {
                await ref
                    .read(hiveProvider)
                    .addPokemonToList(widget.pokemon)
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('pokemon added to the favourites'),
                    ),
                  );
                }).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$e'),
                    ),
                  );
                });
              },
              icon: const Icon(Icons.favorite),
            );
          }),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.pokemon.name!,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  widget.pokemon.id!,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: height * 0.57,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(widget.pokemon.xdescription!),
                  ),
                  PokemonDetailsRow(title: 'Name', value: widget.pokemon.name!),
                  PokemonDetailsRow(
                      title: 'Height', value: widget.pokemon.height!),
                  PokemonDetailsRow(
                    title: 'speed',
                    value: widget.pokemon.speed.toString(),
                  ),
                  PokemonDetailsRow(
                    title: 'type',
                    value: widget.pokemon.typeofpokemon!.join(','),
                  ),
                  PokemonDetailsRow(
                    title: 'weakness',
                    value: widget.pokemon.weaknesses!.join(','),
                  ),
                  PokemonDetailsRow(
                    title: 'special defense',
                    value: widget.pokemon.special_defense.toString(),
                  ),
                  PokemonDetailsRow(
                    title: 'weakness',
                    value: widget.pokemon.weaknesses!.join(','),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: height * 0.12,
            left: (width / 2) - 100,
            child: Image.asset(
              'images/pokeball.png',
              height: 200,
              width: 200,
            ),
          ),
          Positioned(
            top: height * 0.10,
            left: (width / 2) - 100,
            child: Hero(
              tag: widget.pokemon.id!,
              child: CachedNetworkImage(
                imageUrl: widget.pokemon.imageurl!,
                height: 200,
                width: 200,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
