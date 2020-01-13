import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:movies_bloc/blocs/movie_detail_bloc_provider.dart';
import 'package:movies_bloc/ui/movie_detail.dart';
import 'package:movies_bloc/blocs/movies_bloc.dart';
import 'package:movies_bloc/models/item_model.dart';
import 'package:movies_bloc/ui/exhibition_bottom_sheet.dart';

class MovieList extends StatefulWidget {
  @override
  MovieListState createState() {
    return new MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: Text(
          'Vizyondakiler',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 17,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 5.0),
        child: StreamBuilder(
          stream: bloc.allMovies,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return buildList(snapshot);
            } else if (snapshot.hasError) {
              print("Bağlantı Hatası...");
              return Text(snapshot.error.toString());
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
        ),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    double screenHeight = MediaQuery.of(context).size.height;
    return GridView.builder(
      padding: EdgeInsets.only(bottom: screenHeight / 10),
      itemCount: snapshot.data.results.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: InkResponse(
            splashColor: Colors.red,
            enableFeedback: true,
            child: Image.network(
              'https://image.tmdb.org/t/p/w185${snapshot.data.results[index].poster_path}',
              fit: BoxFit.fill,
            ),
            onTap: () => goToMoviesDetailPage(snapshot.data, index),
          ),
        );
      },
    );
  }

  goToMoviesDetailPage(ItemModel data, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MovieDetailBlocProvider(
        child: Stack(
          children: <Widget>[
            MovieDetailScreen(
              title: data.results[index].title,
              //video: data.results[index].video,
              posterUrl: data.results[index].poster_path,
              comment: data.results[index].comment,
              comment2: data.results[index].comment2,
              sube: data.results[index].sube,
              description: data.results[index].overview,
              releaseDate: data.results[index].release_date,
              voteAverage: data.results[index].vote_average.toString(),
              movieId: data.results[index].id,
            ),
            ExhibitionBottomSheet(),
          ],
        ),
      );
    }));
  }
}
