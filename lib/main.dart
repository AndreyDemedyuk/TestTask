import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_5/basketscreen.dart';
import 'package:flutter_application_5/detailscreen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<List<Products>> loadProducts() async {
    final String product = await rootBundle.loadString('assets/data/text.json');
    final List<dynamic> data = jsonDecode(product);

    return data.map((item) => Products.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Basket()),
            );
          },
          icon: Icon(Icons.shopping_basket_sharp),
        ),
      ),
      body: FutureBuilder<List<Products>>(
        future: loadProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text("Ошибка ${snapshot.error}");
          }
          if (!snapshot.hasData) {
            return Text('Данных нет');
          }
          if (snapshot.hasData) {
            List<Products> prod = snapshot.data as List<Products>;
            return ListView.builder(
              itemCount: prod.length,
              itemBuilder: (context, index) {
                final prod1 = prod[index];
                return ProductCard(product: prod1);
              },
            );
          } else {
            return Text("Нет данных");
          }
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Products product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(12.0),
        padding: const EdgeInsets.all(12.0),
        width: 200,
        color: Colors.amber,
        child: Column(
          children: [
            Image.network(product.imageUrl, height: 100, width: 100),
            Text(product.name),
            Text("${product.price}"),
            Text(product.shortDescription),
          ],
        ),
      ),
    );
  }
}

class Products {
  int id;
  String name;
  double price;
  String imageUrl;
  String shortDescription;
  String fullDescription;
  Products(
    this.id,
    this.fullDescription,
    this.imageUrl,
    this.name,
    this.price,
    this.shortDescription,
  );

  Products.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      price = json['price'],
      imageUrl = json['imageUrl'],
      shortDescription = json['shortDescription'],
      fullDescription = json['fullDescription'];
}
