import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parallax_image/parallax_image.dart';
import 'package:movies_bloc/resources/movie_api_provider.dart';
import 'package:url_launcher/url_launcher.dart';

const double minHeight = 120;
const double _minWidth = 220;
double _maxWidth = 330;
List<String> posters = [];

class ExhibitionBottomSheet extends StatefulWidget {
  @override
  _ExhibitionBottomSheetState createState() => _ExhibitionBottomSheetState();
}

class _ExhibitionBottomSheetState extends State<ExhibitionBottomSheet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller; //<-- Create a controller

  double get maxHeight =>
      MediaQuery.of(context).size.height; //<-- Get max height of the screen

  @override
  void initState() {
    super.initState();
    MovieApiProvider mv = new MovieApiProvider();
    mv.fetchUpcomingMovies();
    posters = mv.poster;

    _controller = AnimationController(
      //<-- initialize a controller
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); //<-- and remember to dispose it!
    super.dispose();
  }

  double lerp(double min, double max) => lerpDouble(
      min, max, _controller.value); //<-- lerp any value based on the controller

  double cerp(double max, double min) =>
      lerpDouble(max, min, _controller.value);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      //<--add animated builder
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          height: lerp(maxHeight / 10, maxHeight),
          //<-- update height value to scale with controller
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            //<-- add a gesture detector
            onTap: _toggle,
            onVerticalDragUpdate: _handleDragUpdate,
            //<-- Add verticalDragUpdate callback
            onVerticalDragEnd: _handleDragEnd,
            //<-- on tap...
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(23, 23, 23, 1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top: lerp(maxHeight / 20, maxHeight / 1.7),
                    child: Card(
                      elevation: 4,
                      color: Color.fromARGB(255, 36, 36, 36),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            child: Text(
                              'Pek Yakında',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: maxHeight / 50),
                            width: lerp(maxHeight / 21, maxHeight / 1.8),
                            height: maxHeight / 3.3,
                            child: new Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              constraints:
                                  const BoxConstraints(maxHeight: 210.0),
                              child: new ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: _buildHorizontalChild,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: lerp(maxHeight / 30, maxHeight / 3.2),
                    child: Card(
                      elevation: 8,
                      color: Color.fromARGB(255, 36, 36, 36),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: lerp(320, 330),
                        height: maxHeight / 4.5,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: <Widget>[
                            Container(
                              width: cerp(_maxWidth, _minWidth),
                              color: Colors.black12,
                              margin: EdgeInsets.only(top: 8),
                              padding: EdgeInsets.only(top: 2, bottom: 2),
                              child: Image(
                                  image: AssetImage("assets/uplogoSmall2.png"),
                                  height: lerp(30, 32),
                                  width: lerp(170, 230)),
                            ),
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        width: maxHeight / 15,
                                        color: Colors.black12,
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            top: 5,
                                            right: 0,
                                            bottom: 5),
                                        margin: EdgeInsets.only(
                                            left: 0,
                                            top: cerp(50, 8),
                                            right: 0,
                                            bottom: 8),
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: new RawMaterialButton(
                                                  onPressed: _showSarayDialog,
                                                  child: Icon(
                                                    Icons.phone,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: new RawMaterialButton(
                                                  onPressed: _launchURLMap2,
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: RawMaterialButton(
                                                  onPressed: _launchURLBilet2,
                                                  child: Icon(
                                                    Icons.payment,
                                                    color: Colors.white70,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.black12,
                                    alignment: Alignment.topCenter,
                                    margin: EdgeInsets.only(
                                        left: 10, top: 55, right: 0, bottom: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: Text(
                                            'Saray Sineması',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            '\nHulusi Sayın Cd. Akgün AVM  Kat:1',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 180),
                                          child: Text(
                                            'Elazığ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: lerp(maxHeight / 35, maxHeight / 13),
                    child: Card(
                      elevation: 12,
                      color: Color.fromARGB(255, 36, 36, 36),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: lerp(320, 330),
                        height: maxHeight / 4.5,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: <Widget>[
                            Container(
                              width: cerp(_maxWidth, _minWidth),
                              color: Colors.black12,
                              margin: EdgeInsets.only(top: 8),
                              padding: EdgeInsets.only(top: 2, bottom: 2),
                              child: Image(
                                  image: AssetImage("assets/uplogoSmall.png"),
                                  height: lerp(30, 32),
                                  width: lerp(170, 230)),
                            ),
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        width: maxHeight / 15,
                                        color: Colors.black12,
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            top: 5,
                                            right: 0,
                                            bottom: 5),
                                        margin: EdgeInsets.only(
                                            left: 0,
                                            top: cerp(50, 8),
                                            right: 0,
                                            bottom: 8),
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: new RawMaterialButton(
                                                  onPressed: _showCineworldDialog,
                                                  child: Icon(
                                                    Icons.phone,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: new RawMaterialButton(
                                                  onPressed: _launchURLMap1,
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: RawMaterialButton(
                                                  onPressed: _launchURLBilet1,
                                                  child: Icon(
                                                    Icons.payment,
                                                    color: Colors.white70,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.black12,
                                    margin: EdgeInsets.only(
                                        left: 10, top: 55, right: 0, bottom: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: Text(
                                            'Cineworld23',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            '\nMalatya Yolu Cd. Park23 AVM Kat:3',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 180),
                                          child: Text(
                                            'Elazığ',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    _controller.fling(
        velocity: isOpen ? 2 : 2); //<-- ...snap the sheet in proper direction
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta /
        maxHeight; //<-- Update the _controller.value by the movement done by user.
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy /
        maxHeight; //<-- calculate the velocity of the gesture

    if (flingVelocity < 0.0) {
      _controller.fling(
          velocity:
              math.max(2.0, -flingVelocity)); //<-- either continue it upwards
    } else if (flingVelocity > 0.0) {
      _controller.fling(
          velocity:
              math.min(-2.0, -flingVelocity)); //<-- or continue it downwards
    } else
      _controller.fling(
          velocity: _controller.value < 0.5
              ? -2.0
              : 2.0); //<-- or just continue to whichever edge is closer
  }

  Widget _buildHorizontalChild(BuildContext context, int index) {
    if (_controller.status == AnimationStatus.completed) {
      index++;
      if (index > posters.length) return null;
      return new Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: new ParallaxImage(
          extent: 100.0,
          image: NetworkImage(
              'https://image.tmdb.org/t/p/w500' + posters[index - 1]),
        ),
      );
    }
  }

//Cineworld
  /*
  _launchURLTel1() async {
    const url = 'tel:04245020516';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'wrong url...tel1';
    }
  }
  */
  void _showCineworldDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Cineworld İletişim"),
          content: new Text("0(424) 502 05 16"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _launchURLMap1() async {
    const url = 'https://goo.gl/maps/XcSASnQsDKvcNhS67';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'wrong url...map1';
    }
  }

  _launchURLBilet1() async {
    const url = 'https://www.biletinial.com/mekan/elazig-cineworld-23';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'wrong url...bilet1';
    }
  }

//Saray
  /*
  _launchURLTel2() async {
    const url = 'tel:04242477755';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'wrong url...tel2';
    }
  }
  */
  void _showSarayDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Saray İletişim"),
          content: new Text("0(424) 247 77 55"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _launchURLMap2() async {
    const url = 'https://goo.gl/maps/W9iCjDWYmyBBqBLh7';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'wrong url...map2';
    }
  }

  _launchURLBilet2() async {
    const url = 'https://www.biletinial.com/mekan/elazig-saray-sinemalari';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'wrong url...bilet2';
    }
  }
}
