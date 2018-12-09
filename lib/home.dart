import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<ListPage> {
  ScrollController controller;

  List<String> items = List();

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    removeListener();
    super.dispose();
  }

  void removeListener() {
    controller.removeListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      fetchData();
    }
  }

  http.Response response;
  var pid = 1;
  var isFetching = false;

  Future<List<String>> fetchPost() async {
    response = await http.get('http://dili.bdatu.com/jiekou/mains/p$pid.html');
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      Map<String, Object> mainList = json.decode(response.body);
      List<Object> albums = mainList['album'];
      return albums
          .map((album) => (album as Map<String, Object>)['url'] as String)
          .toList();
    } else {
      removeListener();
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  fetchData() async {
    if (isFetching) {
      return;
    }
    isFetching = true;
    final List<String> response = await fetchPost();
    setState(() {
      items.addAll(response);
    });
    pid++;
    isFetching = false;
    print("pid $pid");
  }

  @override
  Widget build(BuildContext context) {
    var listView = ListView.builder(
//      padding: EdgeInsets.all(8.0),
//      itemExtent: 80.0,
      controller: controller,
      itemCount: items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == items.length) {
          return Align(
              alignment: Alignment.center, child: CircularProgressIndicator());
        }
        return Image.network(items[index]);
      },
    );
    return Scaffold(
//      appBar: AppBar(
//        title: Text("List"),
//      ),
      body: listView,
    );
  }
}
