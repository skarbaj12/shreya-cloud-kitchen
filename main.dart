import 'package:flutter/material.dart';

void main() => runApp(const ShreyaApp());

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<Food,int> cart = {};
  int get total => cart.entries.fold(0, (s,e) => s + e.key.price * e.value);
  int get count => cart.values.fold(0, (s,e) => s + e);

  void add(Food f) => setState(() => cart[f] = (cart[f] ?? 0) + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shreya Cloud Kitchen',
          style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Stack(children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => CartPage(cart: cart, onChanged: () => setState(() {})))),
            ),
            if (count > 0) Positioned(right: 7, top: 6,
              child: CircleAvatar(radius: 9, child: Text('$count',
                style: const TextStyle(fontSize: 10))))
          ])
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.deepOrange.shade50,
            ),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🔥 Special Combo Offer',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('5 Biryani + Chicken Kosha + Raita + Salad'),
                SizedBox(height: 6),
                Text('ONLY ₹500 • FREE DELIVERY',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ]),
          ),
          const SizedBox(height: 20),
          const Text('Popular Food', style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...foods.map((f) => Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(f.emoji, style: const TextStyle(fontSize: 22))),
              title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('₹${f.price}'),
              trailing: FilledButton(onPressed: () => add(f), child: const Text('ADD')),
            ),
          )),
        ],
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final Map<Food,int> cart;
  final VoidCallback onChanged;
  const CartPage({super.key, required this.cart, required this.onChanged});
  @override State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int get total => widget.cart.entries.fold(0, (s,e) => s + e.key.price * e.value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: widget.cart.isEmpty
        ? const Center(child: Text('Cart is empty'))
        : Column(children: [
          Expanded(child: ListView(
            children: widget.cart.entries.map((e) => ListTile(
              title: Text(e.key.name),
              subtitle: Text('₹${e.key.price} × ${e.value}'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(onPressed: () {
                  setState(() {
                    if (e.value <= 1) widget.cart.remove(e.key);
                    else widget.cart[e.key] = e.value - 1;
                  });
                  widget.onChanged();
                }, icon: const Icon(Icons.remove_circle_outline)),
                Text('${e.value}'),
                IconButton(onPressed: () {
                  setState(() => widget.cart[e.key] = e.value + 1);
                  widget.onChanged();
                }, icon: const Icon(Icons.add_circle_outline)),
              ]),
            )).toList(),
          )),
          Padding(padding: const EdgeInsets.all(16), child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: ₹$total', style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold)),
              FilledButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => CheckoutPage(total: total))),
                child: const Text('CHECKOUT'),
              )
            ],
          ))
        ]),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final int total;
  const CheckoutPage({super.key, required this.total});
  @override State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final address = TextEditingController();
  bool requested = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('Order Total: ₹${widget.total}',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        TextField(
          controller: address,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Delivery Address',
            border: OutlineInputBorder(),
            hintText: 'Para / Village / PIN / Mobile',
          ),
        ),
        const SizedBox(height: 20),
        Card(child: ListTile(
          leading: const Icon(Icons.account_balance_wallet),
          title: const Text('UPI Payment'),
          subtitle: const Text('Payment gateway integration required for live payments'),
          trailing: requested ? const Icon(Icons.check_circle) : null,
        )),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: address.text.trim().isEmpty ? null : () {
            setState(() => requested = true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment request sent to admin')));
          },
          icon: const Icon(Icons.send),
          label: const Text('SEND PAYMENT REQUEST'),
        ),
        if (requested) const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Card(child: ListTile(
            leading: Icon(Icons.notifications_active),
            title: Text('Admin notification sent'),
            subtitle: Text('Order will be confirmed after payment verification.'),
          )),
        )
      ]),
    );
  }
}
