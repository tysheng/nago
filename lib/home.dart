import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nago/album.dart';
import 'package:nago/data.dart';
import 'package:nago/http.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<ListPage> {
  ScrollController controller;

  List<Album> items = List();

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  void _removeListener() {
    controller.removeListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      _fetchData();
    }
  }

  Response<String> response;
  var pid = 1;
  var isFetching = false;

  Future<List<Album>> _fetchPost() async {
    response = await Http.instance().get('/mains/p$pid.html');
    Map<String, Object> mainList = json.decode(response.data);
    List<dynamic> albums = mainList['album'];
    return albums.map((album) => Album.create(album)).toList();
  }

  _fetchData() async {
    if (isFetching) {
      return;
    }
    isFetching = true;
    final List<Album> response = await _fetchPost();
    setState(() {
      print(response.join());
      items.addAll(response);
    });
    pid++;
    isFetching = false;
    print("pid $pid");
  }

  _jumpToAlbum(String albumId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlbumPage(albumId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var listView = ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Container(
          height: MediaQuery.of(context).devicePixelRatio * 3,
          color: Color(0x66aaaaaa)),
      controller: controller,
      itemCount: items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == items.length) {
          return Align(
              alignment: Alignment.center, child: CircularProgressIndicator());
        }
        var item = items[index];
        return GestureDetector(
            onTap: () => _jumpToAlbum(item.id),
            child: Container(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsetsDirectional.only(
                            start:
                                MediaQuery.of(context).devicePixelRatio * 3),
                        child: Icon(
                          Icons.arrow_right,
                        ),
                      ),
                      Flexible(
                        child: Container(
                            height:
                                MediaQuery.of(context).devicePixelRatio * 18,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.title,
                                textAlign: TextAlign.start,
                              ),
                            )),
                      ),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                            end: MediaQuery.of(context).devicePixelRatio * 12),
                        child: Text(item.addTime,style: TextStyle(fontSize: 16),),
                      )
                    ],
                  ),
                  Image.network(
                    item.url,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.width * 3 / 4,
                  ),
                ],
              ),
            ));
      },
    );

    return Scaffold(
      body: listView,
    );
  }
}
