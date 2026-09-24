import 'package:flutter/material.dart';

void main() {
  runApp(const ShreyaApp());
}

class Food {
  final String name;
  final int price;
  final String emoji;

  Food(this.name, this.price, this.emoji);
}

final foods = [
  Food('Chicken Biryani', 120, '🍗'),
  Food('Mutton Biryani', 180, '🍖'),
  Food('Chicken Kosha', 140, '🍛'),
  Food('Raita', 30, '🥣'),
  Food('Salad', 25, '🥗'),
];

class ShreyaApp extends StatelessWidget {
  const ShreyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shreya Cloud Kitchen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<Food, int> cart = {};

  int get cartCount =>
      cart.values.fold(0, (sum, quantity) => sum + quantity);

  int get total =>
      cart.entries.fold(0, (sum, item) =>
          sum + item.key.price * item.value);

  void addToCart(Food food) {
    setState(() {
      cart[food] = (cart[food] ?? 0) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shreya Cloud Kitchen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartPage(
                        cart: cart,
                        onChanged: () => setState(() {}),
                      ),
                    ),
                  );
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: CircleAvatar(
                    radius: 9,
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔥 SPECIAL COMBO OFFER',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('5 Biryani + Chicken Kosha + Raita + Salad'),
                SizedBox(height: 8),
                Text(
                  'ONLY ₹500 • FREE DELIVERY',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            '🍽️ Popular Food',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...foods.map(
            (food) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    food.emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                title: Text(
                  food.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('₹${food.price}'),
                trailing: FilledButton(
                  onPressed: () => addToCart(food),
                  child: const Text('ADD'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final Map<Food, int> cart;
  final VoidCallback onChanged;

  const CartPage({
    super.key,
    required this.cart,
    required this.onChanged,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int get total =>
      widget.cart.entries.fold(
        0,
        (sum, item) => sum + item.key.price * item.value,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Your Cart'),
      ),
      body: widget.cart.isEmpty
          ? const Center(
              child: Text('Your
