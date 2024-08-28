import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/data/models/pokemon.dart';
import 'package:pokemon_app/repo/pokemon_repo.dart';

final pokemonFutureProvider =
    FutureProvider.autoDispose<List<Pokemon>>((ref) async {
  final pokemonList = await ref.read(pokemonRepoProvider).getPokemonList();
  return pokemonList;
});
