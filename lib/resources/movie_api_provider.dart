import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:movies_bloc/models/item_model.dart';
import 'package:movies_bloc/models/movie_detail.dart';
import 'dart:convert';

class MovieApiProvider {
  List<String> poster = [];

  http.Client client = http.Client();
  final _apiKey = 'ADD-YOUR-API-KEY';
  final _baseUrl = "https://api.themoviedb.org/3/movie";

  Future<ItemModel> fetchMovieList() async {
    final response = await client.get(
        "https://api.themoviedb.org/4/list/124485?api_key=$_apiKey&language=tr");
    if (response.statusCode == 200) {
      print("Inside 200 status code");
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      final responseeng = await client
          .get("https://api.themoviedb.org/4/list/124485?api_key=$_apiKey");
      if (responseeng.statusCode == 200) {
        print("Inside 200 status code");
        return ItemModel.fromJson(json.decode(response.body));
      } else {
        print("Status code : ${response.statusCode}");
        throw Exception('Failed to load movies list');
      }
    }
  }

  Future<MovieDetail> fetchMovieDetail(int movieId) async {
    final response = await client.get("$_baseUrl/$movieId?api_key=$_apiKey");
    //print(response.body.toString());
    if (response.statusCode == 200) {
      return MovieDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to retrieve Movie Detail');
    }
  }

/*
  Future<ItemModel> fetchUpcomingMovies() async {
    final response = await client.get("http://api.themoviedb.org/3/movie/upcoming?api_key=$_apiKey");
    print(response.body.toString());
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error retrieving upcoming movies');
    }
  } */

  Future fetchUpcomingMovies() async {
    http.Client client = http.Client();
    final response = await client.get(
        "https://api.themoviedb.org/3/movie/upcoming?api_key=1afc6aafac53ed1a17ed12290f133121&language=tr&page=1&region=TR");
    //print(response.body.toString());
    if (response.statusCode == 200) {
      var upcomings = json.decode(response.body);
      for (int i = 0; i < upcomings['results'].length; i++) {
        poster.add(upcomings['results'][i]['poster_path']);
      }
      return print('fetch upcoming finished.');
    } else {
      throw Exception('Error retrieving upcoming movies');
    }
  }
}
