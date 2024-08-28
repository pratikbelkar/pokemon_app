import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/data/models/pokemon.dart';
import 'package:pokemon_app/data/networking/Apiendpoints.dart';
import 'package:pokemon_app/data/networking/dioclient.dart';

class PokemonRepo {
  final Dioclient _dioclient = Dioclient();
  Future getPokemonList() async {
    final response = await _dioclient.get(Apiendpoints.baseUrl);
    // log(response.toString());
    if (response.statusCode == 200) {
      final List<Pokemon> pokemonList = [];
      final decodedData = jsonDecode(response.data);
      decodedData.forEach((pokemon) => {
            pokemonList.add(Pokemon.fromJson(pokemon)),
            log(pokemonList.length.toString()),
          });
      return pokemonList;
    } else {
      log('failed to fetch the pokemonlist');
      Future.error('faild to fetch pokemonlist');
    }
  }
}

final pokemonRepoProvider = Provider((ref) => PokemonRepo());
