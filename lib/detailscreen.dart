import 'package:flutter/material.dart';
import 'package:flutter_application_5/database.dart';
import 'package:flutter_application_5/main.dart';

class DetailScreen extends StatefulWidget {
  final Products product;

  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final SqliteService _sql = SqliteService();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product: ${widget.product.name}")),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            children: [
              Image.network(widget.product.imageUrl),
              const SizedBox(height: 100),
              Text("\t${widget.product.fullDescription}"),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final basketItem = BasketDB(
            name: widget.product.name,
            price: widget.product.price,
          );
          await _sql.createItem(basketItem);
          final snackBar = SnackBar(
            content: Text("Товар добавлен в корзину"),
            duration: Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: const Icon(Icons.arrow_right_alt_sharp),
      ),
    );
  }
}
