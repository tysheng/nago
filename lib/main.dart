import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nago/data.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

const imageUrl =
    'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg';

class ListPageState extends State<ListPage> {
  ScrollController controller;

  List<String> items = new List.generate(5, (index) => imageUrl);

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
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
//    print(controller.position.pixels);
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

  FutureBuilder futureBuilder(int index) {
    return FutureBuilder(
      future: fetchEntry(index),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return SizedBox(
              height: MediaQuery.of(context).size.height * 2,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator()),
            );
          case ConnectionState.done:
          case ConnectionState.active:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var productInfo = snapshot.data;

              return ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text(productInfo['name']),
                subtitle: Text('price: ${productInfo['price']}USD'),
              );
            }
        }
      },
    );
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
              alignment: Alignment.center, child: CircularProgressIndicator()
          );
        }
        return Image.network(items[index]);
      },
    );
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("List"),
      ),
      body: listView,
    );
  }
}

fetchEntry(int index) async {
  await Future.delayed(Duration(milliseconds: 500));

  return {'name': 'product $index', 'price': Random().nextInt(100)};
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:\n',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
