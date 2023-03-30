import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import "package:shopper/main.dart";
import "package:shopper/pages/product_detail.dart";

void main(){
  test("test widget icon is present in the product widget",(WidgetTester tester) async {
    Product product = Product("Name", "12", "https://product-images.ibotta.com/offer/3rY7BleYfo3WHGgiJayX0g-normal.png", "Test Product", "T & Cs", "\$1.0 Cash Back");
    tester.pumpWidget(ProductDetail(key: const Key("1"), product: product));
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  } as Function());
}