import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "../main.dart";

class ProductDetail extends StatefulWidget {
  final Product product;


  const ProductDetail({required Key key, required this.product})
    : super(key:key);


  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
    IconData icon;
    if(appState.favourites.contains(widget.product)){
      icon = Icons.favorite;
    }else{
      icon = Icons.favorite_border;
    }
    return  Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top:20.0),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Image.network(
                    widget.product.url,
                    height: 300.0,
                    width: 300.0,
                    loadingBuilder: (context, child, loadingProgress){
                      if(loadingProgress == null){
                        return child;
                      }
                      return const CircularProgressIndicator();
                    },
                    errorBuilder:(context,error,stackTrace)=> const Text("Image failed to load"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 3.0),
                  child: Text(widget.product.currentvalue, textAlign: TextAlign.left,style: const TextStyle(fontFamily: "AvenirNext-Demi",fontSize: 20.0,fontWeight: FontWeight.bold)),
                ),
                 Text(
                  widget.product.description,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontFamily: "AvenirNext-Demi",fontSize: 14.0,fontWeight: FontWeight.normal),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        appState.addProductToFavourites(widget.product);
                      },
                      icon: Icon(icon,color: Colors.white),
                      label: const Text('Like',style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}