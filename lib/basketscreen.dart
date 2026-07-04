import 'package:flutter/material.dart';
import 'package:flutter_application_5/database.dart';

class Basket extends StatefulWidget {
  const Basket({super.key});

  @override
  State<Basket> createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  final SqliteService _sql = SqliteService();

  double total = 0.0;

  Future<List<BasketDB>> _loadItems() async {
    final items = await _sql.getItems();
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Basket'))),
      body: FutureBuilder(
        future: _loadItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data?.isEmpty == true ) {
            return const Center(child: Text("Basket empty"));
          }
          final items = snapshot.data as List<BasketDB>;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return CardInBasket(
                basket: item,
                child: FloatingActionButton(
                  onPressed: () async {
                    await _sql.deleteItem(item.id!);
                    _deleteFromBasket();
                  },
                  child: Icon(Icons.delete),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FutureBuilder(
        future: _getTotal(),
        builder: (context, snapshot) {
          final total = snapshot.data ?? 0.0;
          return FloatingActionButton(
            onPressed: () {},
            child: Text('${total.toStringAsFixed(2)} \$'),
          );
        },
      ),
    );
  }

  void _deleteFromBasket() async {
    setState(() {});
  }

  Future<double> _getTotal() async {
    return total = await _sql.totalPrice();
  }
}

class CardInBasket extends StatelessWidget {
  final BasketDB basket;
  final Widget child;
  const CardInBasket({super.key, required this.basket, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(12.0),
      width: 200,
      color: const Color.fromARGB(255, 165, 155, 126),
      child: Column(
        children: [Text(basket.name), Text("${basket.price}"), child],
      ),
    );
  }
}
