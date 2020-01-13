import 'package:movies_bloc/models/item_model.dart';
import 'package:movies_bloc/models/movie_detail.dart';
import 'package:movies_bloc/resources/movie_api_provider.dart';
import 'dart:async';

class Repository {
  final MovieApiProvider _movieApiProvider = MovieApiProvider();

  Future<ItemModel> fetchMoviesList() => _movieApiProvider.fetchMovieList();

  Future fetchUpcomingMovies() => _movieApiProvider.fetchUpcomingMovies();

  Future<MovieDetail> fetchMovieDetail(int movieId) =>
      _movieApiProvider.fetchMovieDetail(movieId);
}
