import 'package:flutter/material.dart';
import 'package:movies_bloc/ui/movie_list.dart';
import 'package:movies_bloc/ui/exhibition_bottom_sheet.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            MovieList(),
            ExhibitionBottomSheet(),
          ],
        ),
      ),
    );
  }
}
