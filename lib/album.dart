import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nago/data.dart';
import 'package:nago/http.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flukit/flukit.dart';

class AlbumPage extends StatefulWidget {
  final String _albumId;

  AlbumPage(this._albumId);

  @override
  _AlbumState createState() => _AlbumState(_albumId);
}

class _AlbumState extends State<AlbumPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  String _albumId;
  List<Picture> _list = List();
  bool _loadSuccess = false;
  final PageController _pageController = PageController();
  Picture _currentPicture;

  _AlbumState(String albumId) {
    _albumId = albumId;
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();

    _fetchAlbums(_albumId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _fetchAlbums(String aid) async {
    Response<String> resp = await Http.instance().get('/albums/a$aid.html');
    Map<String, Object> albums = json.decode(resp.data);
    List<dynamic> pictures = albums['picture'];
    List<Picture> pics = pictures.map((pic) => Picture.create(pic)).toList();
    setState(() {
      _list.addAll(pics);
      _loadSuccess = true;

      _setCurrentPicture(0);
    });
  }

  String _indicator() {
    if (_currentPicture == null) {
      return "";
    }
    var index = _list.indexOf(_currentPicture) + 1;
    return "$index/${_list.length}";
  }

  Widget _bottomText() {
    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).devicePixelRatio * 8,
        bottom: MediaQuery.of(context).devicePixelRatio * 8,
        right: MediaQuery.of(context).devicePixelRatio * 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          Text(
            _currentPicture?.content ?? "",
            style: TextStyle(color: Colors.white),
          ),
          Row(
            children: <Widget>[
              Container(
                child: Text(
                  _currentPicture?.author ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).devicePixelRatio * 4),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  _indicator(),
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _albumView(int index) {
    var picture = _list[index];
    var imageView = CachedNetworkImage(
      imageUrl: picture.url,
      placeholder: FittedBox(
        fit: BoxFit.none,
        child: CircularProgressIndicator(),
      ),
      errorWidget: FittedBox(
        fit: BoxFit.none,
        child: Icon(Icons.error),
      ),
    );
    return imageView;
  }

  void _setCurrentPicture(int i) {
    setState(() {
      _currentPicture = _list[i];
    });
  }

  @override
  Widget build(BuildContext mainContext) {
    Widget bottomText = _bottomText();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          PageView.builder(
            itemCount: _list.length,
            controller: _pageController,
            onPageChanged: _setCurrentPicture,
            itemBuilder: (BuildContext context, int index) {
              return ScaleView(
                maxScale: 5,
                child: _albumView(index),
              );
            },
          ),
          bottomText,
          Visibility(
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.none,
                child: CircularProgressIndicator(),
              ),
            ),
            visible: !_loadSuccess,
          )
        ],
      ),
    );
  }
}
