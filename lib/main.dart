import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopper/pages/product_detail.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Shopper App',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: const MyHomePage(title: 'Shopper App'),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier{

  var favourites = <Product>[];

  void addProductToFavourites(Product product){
    if(favourites.contains(product)){
      favourites.remove(product);
    }else{
      favourites.add(product);
    }
    notifyListeners();
  }

}

//Product class 
class Product {
  final String name;
  final String id;
  final String url;
  final String description;
  final String terms;
  final String currentvalue;

  Product(this.name, this.id, this.url, this.description, this.terms,
      this.currentvalue);

  static String getUrl(data) {
    if (data != null) {
      return data;
    } else {
      return "https://product-images.ibotta.com/offer/3rY7BleYfo3WHGgiJayX0g-normal.png";
    }
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(json['name'], json["id"], getUrl(json["url"]),
        json["description"], json["terms"], json["current_value"]);
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Product>> _futureproducts;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _futureproducts = loadMyData();
  }

  Future<List<Product>> loadMyData() async {
    final jsonString =
        await rootBundle.loadString('assets/MobileDevTest/data/Offers.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((json) => Product.fromJson(json)).toList();
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
      body: SafeArea(
        child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: FutureBuilder(
          future: _futureproducts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
                child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 8.0,
                    children: List.from(snapshot.data!.map(
                        (e) => _ProductWidget(e)))),
              );
            } else if (snapshot.hasError) {
              return const Text("Some error has ");
            }
            return const CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}

class _ProductWidget extends StatelessWidget {
  final Product product;


  const _ProductWidget(this.product);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    IconData icon;

    if(appState.favourites.contains(product)){
      icon = Icons.favorite;
    }else{
      icon = Icons.favorite_border_sharp;
    }
    return Scaffold(
      body: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProductDetail(product:product, key: const Key("1"))));
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.network(
                product.url,
                height: 100.0,
                width: 100.0,
                loadingBuilder: (context,child,loadingProgress){
                  if(loadingProgress == null){
                    return child;
                  }
                  return const CircularProgressIndicator();
                },
                errorBuilder: (context,child,stackTrace)=> const Text("Image could not be loaded"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 3.0),
              child: Row(
                children: [
                  Text(product.currentvalue, textAlign: TextAlign.left,style: const TextStyle(fontFamily: "AvenirNext-Demi",fontSize: 12.0,fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5.0),
                  Icon(icon,color: Colors.redAccent)
                ],
              ),
            ),
            Text(
              product.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: "AvenirNext-Demi",fontSize: 11.0,fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
